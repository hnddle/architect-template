#!/usr/bin/env bash
# 스펙 커버리지 검사 — 「빠짐없이」를 사람 눈이 아니라 명령으로 확인한다.
# 의존 없음(bash · grep · awk · sed · sort). macOS 기본 bash 3.2 에서도 돈다.
#
# 쓰는 법
#   scripts/check-spec-coverage.sh                 specs/NNN-*/ 전부
#   scripts/check-spec-coverage.sh specs/001-x     지정한 스펙만(전역 검사는 늘 전부)
#   scripts/check-spec-coverage.sh --ids FR 1 40 [--skip 7,12] [--width 3] --in FILE...
#                                                  상위 문서 ID(FR-001~FR-040)가 FILE 에 전건 나오는지
#
# 검사(스펙마다)
#   1. ID 결번   — FR · NFR · SC · R 정의가 건너뛴 번호에 결번 줄(~~FR-034~~)이 있는가
#   2. ID 등장   — 살아 있는 FR 이 tasks.md 에, 결정(D)이 plan.md 에 나오는가(파일이 있을 때만)
#   3. 결정 행   — | D-nnn | 행의 칸이 비지 않았는가(ID · 결정 · 근거 최소 3칸)
#   4. 태스크 형식 — tasks.md 의 「- [ ] T001 [P] [US1] 설명」 형식 · T 번호 중복
# 검사(전역)
#   5. 결정 번호 충돌 — 같은 D 번호를 두 스펙이 정의
#   6. 레지스트리   — 정의한 D 번호가 specs/DECISIONS.md 에 그 스펙 몫으로 예약된 범위 안인가
#   7. 스펙 번호   — 같은 번호 디렉터리 둘 · (MIGRATIONS_DIR 을 주면) 번호로 시작하는 이행 파일에 맞는 스펙 디렉터리 없음
#
# 환경변수
#   MIGRATIONS_DIR  데이터 이행 폴더(저장소 루트 기준). 파일 이름이 스펙 번호 세 자리로 시작한다고 본다. 없으면 건너뛴다
#
# 끝나는 코드: FAIL 이 하나라도 있으면 1, 아니면 0(WARN 만 있으면 0). 스펙이 없으면 0.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPECS="$ROOT/specs"
REGISTRY="$SPECS/DECISIONS.md"
MIGRATIONS="${MIGRATIONS_DIR:+$ROOT/$MIGRATIONS_DIR}"
fails=0
warns=0
TMP="$(mktemp -d "${TMPDIR:-/tmp}/spec-coverage.XXXXXX")"
trap 'rm -r "$TMP"' EXIT

fail() { echo "FAIL $*"; fails=$((fails + 1)); }
warn() { echo "WARN $*"; warns=$((warns + 1)); }

usage() {
  sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

# 숫자 목록(한 줄에 하나)에서 min~max 사이 빠진 번호를 찍는다.
gaps() {
  sort -n -u | awk 'NR==1{p=$1; next} {for(i=p+1;i<$1;i++) print i; p=$1}'
}

# --- 모드 1: 상위 문서 ID 전건 등장 -----------------------------------------
if [ "${1:-}" = "--ids" ]; then
  [ $# -ge 6 ] || usage
  prefix="$2"; start="$3"; end="$4"; shift 4
  skip=","; width=3; files=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --skip)  skip=",$2,"; shift 2 ;;
      --width) width="$2"; shift 2 ;;
      --in)    shift; files="$*"; break ;;
      *) usage ;;
    esac
  done
  [ -n "$files" ] || usage
  for f in $files; do [ -f "$f" ] || { echo "FAIL 파일 없음: $f"; exit 1; }; done
  missing=0
  for n in $(seq "$start" "$end"); do
    case "$skip" in *",$n,"*) continue ;; esac
    id="$(printf "%s-%0${width}d" "$prefix" "$n")"
    # shellcheck disable=SC2086
    if ! grep -qE "(^|[^0-9A-Za-z])$id([^0-9]|$)" $files; then
      echo "미커버 $id"; missing=$((missing + 1))
    fi
  done
  skipped="$(printf '%s' "$skip" | sed 's/^,//; s/,$//')"
  echo "미커버 ${missing}건 ($(printf "%s-%0${width}d" "$prefix" "$start") ~ $(printf "%s-%0${width}d" "$prefix" "$end"), 건너뜀 ${skipped:-없음})"
  [ "$missing" -eq 0 ]
  exit $?
fi

case "${1:-}" in -h|--help) usage ;; esac

# --- 대상 스펙 고르기 --------------------------------------------------------
all_specs=""
if [ -d "$SPECS" ]; then
  for d in "$SPECS"/[0-9][0-9][0-9]-*/; do
    [ -d "$d" ] && all_specs="$all_specs ${d%/}"
  done
fi
targets=""
if [ $# -gt 0 ]; then
  for a in "$@"; do
    d="$(cd "$a" 2>/dev/null && pwd)" || { fail "스펙 디렉터리 없음: $a"; continue; }
    targets="$targets $d"
  done
else
  targets="$all_specs"
fi

if [ -z "$all_specs" ] && [ -z "$targets" ]; then
  echo "검사할 스펙 없음 (specs/NNN-*/ 가 비어 있다)"
  exit 0
fi

# 정의 줄: **FR-001** · | FR-001 | · ~~FR-001~~ 로 시작하는 표 칸
defined_ids() { # $1=prefix $2=file → 「번호<TAB>상태(live|dead)」
  grep -E "(\*\*|~~|^\| )$1-[0-9]+([^0-9A-Za-z]|$)" "$2" 2>/dev/null | while IFS= read -r line; do
    id="$(printf '%s\n' "$line" | grep -oE "(\*\*|~~|^\| )$1-[0-9]+" | head -1 | grep -oE '[0-9]+$')"
    [ -n "$id" ] || continue
    case "$line" in
      *"~~$1-"*|*결번*|*폐지*) state=dead ;;
      *) state=live ;;
    esac
    printf '%s\t%s\n' "$((10#$id))" "$state"
  done
}

width_of() { # 그 접두의 첫 ID 자릿수
  grep -oE "$1-[0-9]+" "$2" 2>/dev/null | head -1 | sed "s/^$1-//" | awk '{print length($0)}'
}

check_spec() {
  dir="$1"; name="$(basename "$dir")"
  spec="$dir/spec.md"; plan="$dir/plan.md"; tasks="$dir/tasks.md"
  if [ ! -f "$spec" ]; then
    echo "FAIL $name: spec.md 없음 — 이행 파일만 있는 번호라도 최소 spec.md 를 둔다"
    return
  fi

  # 1 · 2. ID 결번과 등장
  for p in FR NFR SC R; do
    defined_ids "$p" "$spec" > "$TMP/ids"
    [ -s "$TMP/ids" ] || continue
    w="$(width_of "$p" "$spec")"; [ -n "$w" ] || w=3
    cut -f1 "$TMP/ids" | gaps | while read -r n; do
      echo "FAIL $name: $(printf "%s-%0${w}d" "$p" "$n") 결번 사유 없음 — 「~~$p-…~~: 결번 — 사유」 줄을 남긴다"
    done
    if [ "$p" = "FR" ] && [ -f "$tasks" ]; then
      awk -F'\t' '$2=="live"{print $1}' "$TMP/ids" | sort -n -u | while read -r n; do
        id="$(printf "FR-%0${w}d" "$n")"
        grep -qE "$id([^0-9]|$)" "$tasks" || echo "FAIL $name: $id 가 tasks.md 에 없다"
      done
    fi
  done

  # 3. 결정 행
  grep -nE '^\| D-[0-9]+ ' "$spec" > "$TMP/drows" || true
  while IFS= read -r row; do
    ln="${row%%:*}"; body="${row#*:}"
    awk -F'|' -v ln="$ln" -v nm="$name" '{
      n=0; empty=0
      for (i=2; i<NF; i++) { c=$i; gsub(/^[ \t]+|[ \t]+$/, "", c); n++; if (c=="") empty++ }
      if (n < 3) printf "FAIL %s: spec.md:%s 결정 행 칸이 %d개 — ID · 결정 · 근거가 필요하다\n", nm, ln, n
      else if (empty > 0) printf "FAIL %s: spec.md:%s 결정 행에 빈 칸 %d개 — 「없음」이라도 적는다\n", nm, ln, empty
    }' <<EOF
$body
EOF
    id="$(printf '%s\n' "$body" | grep -oE '^\| D-[0-9]+' | grep -oE 'D-[0-9]+')"
    printf '%s\t%s\n' "$id" "$name" >> "$TMP/all_decisions"
    if [ -f "$plan" ] && ! grep -qE "$id([^0-9]|$)" "$plan"; then
      echo "WARN $name: $id 가 plan.md 에 없다 — 결정 커버리지 표에 반영 절을 적는다"
    fi
  done < "$TMP/drows"

  # 4. 태스크 형식
  if [ -f "$tasks" ]; then
    grep -nE '^- \[[ xX]\] ' "$tasks" > "$TMP/trows" || true
    while IFS= read -r row; do
      ln="${row%%:*}"; body="${row#*:}"
      printf '%s\n' "$body" | grep -qE '^- \[[ xX]\] T[0-9]{3,}( \[P\])?( \[US[0-9]+\])? [^ ]' \
        || echo "FAIL $name: tasks.md:$ln 형식 — 「- [ ] T001 [P] [US1] 설명」"
    done < "$TMP/trows"
    grep -oE '^- \[[ xX]\] T[0-9]{3,}' "$tasks" | grep -oE 'T[0-9]+' | sort | uniq -d | while read -r t; do
      echo "FAIL $name: tasks.md 에 $t 가 두 번 있다"
    done
  fi
}

: > "$TMP/all_decisions"
: > "$TMP/out"
# 전역 검사는 늘 전부를, 스펙별 출력은 대상만 보인다.
for d in $all_specs; do
  case " $targets " in
    *" $d "*) check_spec "$d" >> "$TMP/out" ;;
    *) check_spec "$d" > /dev/null ;;
  esac
done
for d in $targets; do
  case " $all_specs " in *" $d "*) ;; *) check_spec "$d" >> "$TMP/out" ;; esac
done
grep -c '^FAIL' "$TMP/out" > "$TMP/n" || true
fails=$((fails + $(cat "$TMP/n")))
grep -c '^WARN' "$TMP/out" > "$TMP/n" || true
warns=$((warns + $(cat "$TMP/n")))
cat "$TMP/out"

# 5. 결정 번호 충돌
sort -u "$TMP/all_decisions" | cut -f1 | uniq -d | while read -r id; do
  echo "FAIL 결정 번호 충돌: $id — $(awk -F'\t' -v id="$id" '$1==id{printf "%s ", $2}' "$TMP/all_decisions")"
done > "$TMP/dup"
[ -s "$TMP/dup" ] && { cat "$TMP/dup"; fails=$((fails + $(wc -l < "$TMP/dup"))); }

# 6. 레지스트리 범위
if [ -s "$TMP/all_decisions" ]; then
  if [ ! -f "$REGISTRY" ]; then
    fail "specs/DECISIONS.md 없음 — 결정 번호 범위를 먼저 예약한다"
  else
    # | D-001 ~ D-020 | 001-sample | … → 「시작 끝 스펙」
    grep -E '^\| D-[0-9]+ ~ D-[0-9]+ \|' "$REGISTRY" \
      | awk -F'|' '{r=$2; s=$3; gsub(/[ `]/,"",r); gsub(/[ `]/,"",s); split(r,a,"~"); sub(/^D-/,"",a[1]); sub(/^D-/,"",a[2]); print a[1]+0, a[2]+0, s}' \
      > "$TMP/ranges"
    sort -u "$TMP/all_decisions" | while IFS="$(printf '\t')" read -r id spec; do
      n="${id#D-}"; n=$((10#$n))
      awk -v n="$n" -v s="$spec" '$1<=n && n<=$2 && $3==s {ok=1} END{exit !ok}' "$TMP/ranges" \
        || echo "FAIL $id ($spec): specs/DECISIONS.md 에 이 스펙 몫으로 예약된 범위가 아니다"
    done > "$TMP/reg"
    [ -s "$TMP/reg" ] && { cat "$TMP/reg"; fails=$((fails + $(wc -l < "$TMP/reg"))); }
  fi
fi

# 7. 스펙 번호
for d in $all_specs; do basename "$d" | cut -c1-3; done | sort | uniq -d | while read -r n; do
  echo "FAIL 스펙 번호 $n 디렉터리가 둘 이상 — mkdir 직전에 ls specs/ 로 확인한다"
done > "$TMP/num"
if [ -n "$MIGRATIONS" ] && [ -d "$MIGRATIONS" ]; then
  for f in "$MIGRATIONS"/[0-9][0-9][0-9]*; do
    [ -f "$f" ] || continue
    n="$(basename "$f" | cut -c1-3)"
    ls -d "$SPECS/$n"-*/ > /dev/null 2>&1 || echo "FAIL 이행 파일 $(basename "$f") 의 번호 $n 에 맞는 스펙 디렉터리가 없다"
  done >> "$TMP/num"
fi
[ -s "$TMP/num" ] && { cat "$TMP/num"; fails=$((fails + $(wc -l < "$TMP/num"))); }

echo "결과: FAIL ${fails}건 · WARN ${warns}건"
[ "$fails" -eq 0 ]
