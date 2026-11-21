#!/usr/bin/env bash
# 누출 · 남은 견본 검사.
#   1) --terms 파일의 패턴이 저장소에 나오면 실패한다. 다른 프로젝트에서 규칙 · 코드를 옮겨 올 때 그 프로젝트의
#      이름 · 회사 정보 · 실데이터 · 업무 용어가 따라오지 않았는지 본다. 패턴 파일은 한 줄에 확장 정규식 하나,
#      # 로 시작하면 주석. 이 파일은 저장소 밖에 둔다(값 자체가 누출이라서).
#   2) 템플릿의 예시 도메인(샘플서비스 · 공유 회의실 예약)이 프로젝트 문서(docs · specs · 코드)에 남았는지 알린다.
#      규칙 문서(.claude · .specify)의 예시는 일부러 남기는 것이라 세지 않는다.
#   3) 사람이 채울 문서 빈칸 <…>(꺾쇠 안 한글)이 남은 파일을 알린다.
#
# 쓰는 법: scripts/check-leaks.sh [--terms <파일>]... [--strict] [--list]
#   --strict  2)도 실패로 친다(출시 전 점검용)
#   --list    걸린 줄을 보여 준다(기본은 파일 이름과 건수만 — 민감한 값을 화면에 다시 찍지 않기 위해)
# 끝 코드: 1)에 걸리면 1, --strict 에서 2)에 걸려도 1, 아니면 0.
set -euo pipefail
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

TERMS=()
STRICT=0
LIST=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --terms) [ -f "${2:-}" ] || { echo "패턴 파일이 없습니다: ${2:-}" >&2; exit 2; }; TERMS+=("$2"); shift 2 ;;
    --strict) STRICT=1; shift ;;
    --list) LIST=1; shift ;;
    -h|--help) sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "모르는 인자: $1" >&2; exit 2 ;;
  esac
done

SELF=(scripts/check-leaks.sh)
# 의존성 · 빌드 산출물 폴더는 보지 않는다. 스택에 맞춰 더한다.
EXCLUDES=(--exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=.venv --exclude-dir=build
  --exclude-dir=dist --exclude-dir=target --exclude-dir=.idea --exclude=.DS_Store)
for s in "${SELF[@]}"; do EXCLUDES+=("--exclude=$(basename "$s")"); done

# grep 결과에서 스크립트 자신을 한 번 더 걸러 낸다(같은 이름의 다른 파일까지 빠지지 않게 경로로 비교)
not_self() {
  local line path
  while IFS= read -r line; do
    path="${line%%:*}"; path="${path#./}"
    case " ${SELF[*]} " in *" $path "*) continue ;; esac
    printf '%s\n' "$line"
  done
}

report() { # report <제목> <grep 인자...>  → 걸린 파일 수를 돌려준다(stdout 마지막 줄)
  local title="$1"; shift
  local hits
  hits="$(grep -rnIE "${EXCLUDES[@]}" "$@" . 2>/dev/null | not_self || true)"
  if [ -z "$hits" ]; then
    echo "  [없음] $title"
    echo 0
    return
  fi
  local files
  files="$(printf '%s\n' "$hits" | cut -d: -f1 | sort -u)"
  echo "  [걸림] $title — 파일 $(printf '%s\n' "$files" | wc -l | tr -d ' ')개 · 줄 $(printf '%s\n' "$hits" | wc -l | tr -d ' ')개"
  if [ $LIST -eq 1 ]; then printf '%s\n' "$hits" | sed 's/^/      /' | cut -c1-220; else printf '%s\n' "$files" | sed 's/^/      /' | head -40; fi
  printf '%s\n' "$files" | wc -l | tr -d ' '
}

status=0

echo "1) 다른 프로젝트에서 따라온 값(--terms)"
if [ ${#TERMS[@]} -eq 0 ]; then
  echo "  [건너뜀] --terms 파일이 없습니다"
else
  for t in "${TERMS[@]}"; do
    while IFS= read -r pat || [ -n "$pat" ]; do
      [ -z "${pat// /}" ] && continue
      [[ "$pat" == \#* ]] && continue
      out="$(report "패턴 #$(grep -nxF -- "$pat" "$t" | head -1 | cut -d: -f1) ($t)" -e "$pat")"
      n="$(printf '%s\n' "$out" | tail -1)"
      printf '%s\n' "$out" | sed '$d'
      [ "$n" -gt 0 ] && status=1
    done < "$t"
  done
fi

echo "2) 남은 예시 도메인"
sample_hits=0
out="$(report "예시 도메인(샘플서비스 · 회의실 예약 — 실제 내용으로 바꾸면 사라진다)" --exclude-dir=.claude --exclude-dir=.specify --exclude-dir=scripts --exclude-dir=_templates --exclude=README.md --exclude=CLAUDE.md -e '샘플서비스' -e '[Rr]eservation' -e '회의실')"
sample_hits="$(printf '%s\n' "$out" | tail -1)"
printf '%s\n' "$out" | sed '$d'
[ $STRICT -eq 1 ] && [ $sample_hits -gt 0 ] && status=1

echo "3) 사람이 채울 빈칸 <…>"
# 양식 파일(규칙 · 스킬 · 스펙 양식 · 원자료 빈 양식)의 빈칸은 일부러 둔 것이라 세지 않는다
out="$(report "꺾쇠 빈칸" --exclude-dir=rules --exclude-dir=skills --exclude-dir=templates --exclude-dir=_templates --exclude-dir=scripts --exclude='_template-*' --exclude=README.md -e '<[가-힣][^<>]{0,40}>')"
printf '%s\n' "$out" | sed '$d'

if [ $status -eq 0 ]; then echo "결과: 통과"; else echo "결과: 실패"; fi
exit $status
