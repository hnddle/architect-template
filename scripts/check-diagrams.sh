#!/usr/bin/env bash
# 설계 다이어그램 정합성 검사 — docs/04.design 의 집합 · 커버리지 · 링크 · 정본 블록 · 모듈 매핑을 센다.
# bash 와 기본 유틸(grep · sed · awk · comm · find)만 쓴다. 언어 · 프레임워크와 무관하다.
#
#   scripts/check-diagrams.sh             # 기본 검사
#   scripts/check-diagrams.sh --mermaid   # + Mermaid 블록을 로컬 브라우저로 그려 문법 확인(선택)
#   CODE_ROOTS="api/src" scripts/check-diagrams.sh   # + 코드 최상위 모듈 ↔ 03 매핑표
#
# 숫자 · 집합을 문서에 손으로 옮겨 적지 않으려고 둔다(diagram-workflow §7). 실패가 하나라도 있으면 1 로 끝난다.
# 03_c4_component.md 에 골격 표식(check-diagrams:skeleton)이 있는 동안 FR · NFR 커버리지 누락은 경고로 센다.
#
# 환경변수
#   CODE_ROOTS  컴포넌트를 가진 컨테이너의 소스 루트(공백으로 여럿). 그 바로 아래 폴더를 최상위 모듈로 본다
#   MERMAID_JS  mermaid.min.js 경로 (--mermaid 에 필요. 저장소는 들고 있지 않다)
#   CHROME      Chrome · Chromium 실행 파일 (기본: macOS Chrome → PATH 의 google-chrome · chromium)
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESIGN="$ROOT/docs/04.design"
D="$DESIGN/01.architecture/01.diagram"
SRS="$ROOT/docs/03.srs"
C03="$D/03_c4_component.md"

fails=0; warns=0
ok()   { echo "  통과    $*"; }
bad()  { echo "  실패    $*"; fails=$((fails + 1)); }
warn() { echo "  경고    $*"; warns=$((warns + 1)); }
skip() { echo "  건너뜀  $*"; }
section() { echo; echo "■ $*"; }
# 입력 목록 중 비어 있지 않은 줄만 "a · b · c" 로
join_lines() { awk 'NF' | paste -sd'|' - | sed 's/|/ · /g'; }

[ -d "$D" ] || { echo "설계 문서 폴더가 없다 ($D) — 검사할 것이 없다"; exit 0; }

# 표의 활성 ID 행(| `ID` |)에서 ID 만 — 취소선 행(| ~~`ID`~~ |)은 빠진다
table_ids() { # $1 = 접두(FR|NFR|CON|CMP|UC), $2.. = 파일
  local p="$1"; shift
  grep -hE "^\| \`$p-[0-9]+\` \|" "$@" 2>/dev/null | sed -E "s/^\| \`($p-[0-9]+)\`.*/\1/" | sort -u
}
# 파일에 나오는 ID 전부
all_ids() { # $1 = 접두, $2.. = 파일
  local p="$1"; shift
  # 앞뒤 글자까지 한 낱말로 잘라 NFR-001(FR 아님) · CMP-2xx(자리표시자)를 걸러 낸다
  grep -ohE "[A-Z]*$p-[0-9]+[0-9a-z]*" "$@" 2>/dev/null | grep -E "^$p-[0-9]+$" | sort -u
}
existing() { for f in "$@"; do [ -f "$f" ] && echo "$f"; done; }

is_skeleton=0
[ -f "$C03" ] && grep -q 'check-diagrams:skeleton' "$C03" && is_skeleton=1

# ── 1. FR · NFR 커버리지 ───────────────────────────────────────────
section "FR · NFR 커버리지 (SRS → 03 대응표)"
srs_active() { # $1 = FR|NFR — SRS 제목 「## FR-001 …」, 결번은 「## ~~FR-034~~」라 빠진다
  [ -d "$SRS" ] || return 0
  # HTML 주석 안의 예시 항목은 세지 않는다
  awk '/<!--/{c=1} !c{print} /-->/{c=0}' "$SRS"/*.md 2>/dev/null | grep -E "^#{2,4} +$1-[0-9]+" | sed -E "s/^#{2,4} +($1-[0-9]+).*/\1/" | sort -u
}
for kind in FR NFR; do
  active="$(srs_active "$kind")"
  if [ ! -f "$C03" ]; then skip "$kind — 03_c4_component.md 없음"; continue; fi
  if [ -z "$active" ]; then skip "$kind — SRS 에 활성 $kind 제목(## $kind-###)이 없다"; continue; fi
  missing="$(comm -23 <(echo "$active") <(table_ids "$kind" "$C03"))"
  extra="$(comm -13 <(echo "$active") <(table_ids "$kind" "$C03"))"
  n="$(echo "$active" | grep -c .)"
  report=bad; [ "$is_skeleton" = 1 ] && report=warn
  if [ -n "$missing" ]; then $report "$kind 대응표에 없음: $(echo "$missing" | join_lines)"; else ok "$kind 활성 ${n}건 전부 대응"; fi
  if [ -n "$extra" ]; then $report "$kind 대응표에만 있고 SRS 에 활성으로 없음: $(echo "$extra" | join_lines)"; fi
done

# ── 2. CON 집합 ────────────────────────────────────────────────────
section "CON 집합 (02 정본)"
C02="$D/02_c4_container.md"; C07="$D/07_deployment_architecture.md"
if [ -f "$C02" ]; then
  users="$(existing "$D"/03*.md "$D"/04_*.md "$D"/05*.md "$D"/06_*.md "$C07" "$D"/09_*.md "$D"/10_*.md)"
  if [ -n "$users" ]; then
    # shellcheck disable=SC2086
    unknown="$(comm -23 <(all_ids CON $users) <(all_ids CON "$C02"))"
    [ -n "$unknown" ] && bad "02 에 없는 CON 을 쓴다: $(echo "$unknown" | join_lines)" || ok "다른 문서가 쓰는 CON 은 전부 02 에 있다"
  fi
  if [ -f "$C07" ]; then
    # 07 은 §2 대응표만 본다 — 진입 경로 표에도 `CON-###` 로 시작하는 행이 있다
    undeployed="$(comm -23 <(table_ids CON "$C02") <(awk '/^## 2\./{on=1;next} /^## /{on=0} on' "$C07" | table_ids CON -))"
    [ -n "$undeployed" ] && bad "07 대응표에 없는 활성 CON: $(echo "$undeployed" | join_lines)" || ok "활성 CON $(table_ids CON "$C02" | grep -c .)건 전부 07 대응표에 있다"
  else skip "07 없음"; fi
else skip "02_c4_container.md 없음"; fi

# ── 3. CMP 집합 ────────────────────────────────────────────────────
section "CMP 집합 (03 목차 = 03a/b/c)"
splits="$(existing "$D"/03[a-z]_*.md)"
if [ -f "$C03" ] && [ -n "$splits" ]; then
  # shellcheck disable=SC2086
  d1="$(comm -23 <(all_ids CMP "$C03") <(all_ids CMP $splits))"
  # shellcheck disable=SC2086
  d2="$(comm -13 <(all_ids CMP "$C03") <(all_ids CMP $splits))"
  [ -n "$d1" ] && bad "03 목차에만 있음: $(echo "$d1" | join_lines)"
  [ -n "$d2" ] && bad "분할 문서에만 있음: $(echo "$d2" | join_lines)"
  [ -z "$d1$d2" ] && ok "CMP $(all_ids CMP "$C03" | grep -c .)건 일치"
else skip "03 목차 또는 분할 문서 없음"; fi

# ── 4. UC 집합 ─────────────────────────────────────────────────────
section "UC 집합 (04 = 05 ∪ 05x, 06 ⊆ 04)"
C04="$D/04_use_case_diagram.md"
scen="$(existing "$D"/05_use_case_scenarios.md "$D"/05[a-z]_*.md)"
if [ -f "$C04" ] && [ -n "$scen" ]; then
  # shellcheck disable=SC2086
  d1="$(comm -23 <(all_ids UC "$C04") <(all_ids UC $scen))"
  # shellcheck disable=SC2086
  d2="$(comm -13 <(all_ids UC "$C04") <(all_ids UC $scen))"
  [ -n "$d1" ] && bad "04 에만 있음: $(echo "$d1" | join_lines)"
  [ -n "$d2" ] && bad "05 에만 있음: $(echo "$d2" | join_lines)"
  [ -z "$d1$d2" ] && ok "UC $(all_ids UC "$C04" | grep -c .)건 일치 (활성 $(table_ids UC "$C04" | grep -c .))"
  if [ -f "$D/06_activity_diagram.md" ]; then
    d3="$(comm -23 <(all_ids UC "$D/06_activity_diagram.md") <(all_ids UC "$C04"))"
    [ -n "$d3" ] && bad "06 이 04 에 없는 UC 를 쓴다: $(echo "$d3" | join_lines)" || ok "06 의 UC 는 전부 04 에 있다"
  fi
else skip "04 또는 05 없음"; fi

# ── 5. 액터 ────────────────────────────────────────────────────────
section "액터 (04 §1 ⊆ 01)"
C01="$D/01_c4_context.md"
if [ -f "$C04" ] && [ -f "$C01" ]; then
  actors="$(awk '/^## 1\./{on=1;next} /^## /{on=0} on' "$C04" | grep -E '^\| *[0-9]+ *\|' | awk -F'|' '{gsub(/^ +| +$/,"",$3); print $3}')"
  n=0; missing=""
  while IFS= read -r a; do
    [ -z "$a" ] && continue; n=$((n + 1))
    case "$a" in *System) continue ;; esac   # 시스템 주체는 01 의 Person 이 아니다
    grep -qF "$a" "$C01" || missing="$missing $a"
  done <<< "$actors"
  [ -n "$missing" ] && bad "01 에 없는 액터:$missing" || ok "액터 ${n}명 전부 01 에 있다"
else skip "01 또는 04 없음"; fi

# ── 6. 결번 ID ─────────────────────────────────────────────────────
section "결번 ID (~~ID~~) 의 활성 인용"
md_files="$(find "$DESIGN" -name '*.md' -type f 2>/dev/null | sort)"
retired="$(echo "$md_files" | xargs grep -ohE '~~`?(FR|NFR|CON|CMP|UC)-[0-9]+`?~~' 2>/dev/null | grep -oE '(FR|NFR|CON|CMP|UC)-[0-9]+' | sort -u)"
if [ -z "$retired" ]; then ok "결번 ID 없음"; else
  hits=""
  for id in $retired; do
    lines="$(echo "$md_files" | xargs grep -nE "(^|[^A-Z])$id([^0-9]|$)" 2>/dev/null | grep -v "~~\`\?$id\`\?~~" | grep -vE '결번|삭제|폐기|되살' || true)"
    [ -n "$lines" ] && hits="$hits"$'\n'"$(echo "$lines" | sed "s|^$ROOT/|    |")"
  done
  if [ -n "$hits" ]; then
    n="$(echo "$hits" | grep -c .)"
    bad "결번 ID 를 결번 표기 없이 쓴다 (${n}곳, 앞 10곳):$(echo "$hits" | head -11)"
  else ok "결번 $(echo "$retired" | grep -c .)건 — 활성 인용 없음"; fi
fi

# ── 7. 링크 ────────────────────────────────────────────────────────
section "상대 링크"
broken=""; nlinks=0
while IFS= read -r f; do
  [ -z "$f" ] && continue
  dir="$(dirname "$f")"
  while IFS= read -r target; do
    [ -z "$target" ] && continue
    case "$target" in http://*|https://*|mailto:*|\#*|*\<*) continue ;; esac
    path="${target%%#*}"; nlinks=$((nlinks + 1))
    [ -e "$dir/$path" ] || broken="$broken"$'\n'"    ${f#"$ROOT"/} → $target"
  done < <(grep -oE '\]\([^)[:space:]]+\)' "$f" | sed -E 's/^\]\((.*)\)$/\1/')
done <<< "$md_files"
[ -n "$broken" ] && bad "깨진 링크:$broken" || ok "상대 링크 ${nlinks}개 전부 존재"

# ── 8. 정본 블록 ───────────────────────────────────────────────────
section "정본 블록 (Mermaid 블록 · 다른 문법의 두 번째 원본 없음)"
for f in $(existing "$C01" "$C02" "$D"/03[a-z]_*.md "$C04" "$D/06_activity_diagram.md" "$C07" "$D"/09_*.md "$D"/10_*.md); do
  n="$(grep -c '^```mermaid' "$f")"
  base="$(basename "$f")"
  if [ "$n" -lt 1 ]; then bad "$base — Mermaid 블록이 없다"
  elif [ "$base" = "06_activity_diagram.md" ] && [ "$n" -ne 1 ]; then bad "$base — 흐름 정본 블록이 ${n}개다 (하나여야 한다)"
  fi
done
puml="$( { find "$DESIGN" -name '*.puml' -type f; echo "$md_files" | xargs grep -lE '^(```plantuml|@startuml)' 2>/dev/null; } | sed "s|$ROOT/||")"
[ -n "$puml" ] && bad "PlantUML 소스가 남아 있다: $(echo "$puml" | join_lines)" || ok "다이어그램 문서마다 Mermaid 블록 · 06 은 하나 · PlantUML 없음"

# ── 9. 모듈 매핑 (CODE_ROOTS) ──────────────────────────────────────
section "코드 최상위 모듈 ↔ 03 매핑표"
if [ -z "${CODE_ROOTS:-}" ]; then skip "CODE_ROOTS 없음 — 코드가 생기면 컴포넌트를 가진 컨테이너의 소스 루트를 준다 (예: CODE_ROOTS=\"api/src\")"
elif [ ! -f "$C03" ]; then skip "03 없음"
else
  code_mods=""
  for r in $CODE_ROOTS; do
    case "$r" in /*) dir="$r" ;; *) dir="$ROOT/$r" ;; esac
    if [ -d "$dir" ]; then
      code_mods="$code_mods"$'\n'"$(find "$dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)"
    else bad "CODE_ROOTS 의 $r 폴더가 없다"; fi
  done
  code_mods="$(echo "$code_mods" | grep . | sort -u)"
  mapped="$(grep -hE '^\| `CMP-[0-9]+` \| `[A-Za-z0-9_.-]+` \|' "$C03" | sed -E 's/^\| `CMP-[0-9]+` \| `([A-Za-z0-9_.-]+)`.*/\1/' | sort -u)"
  declared_non="$(grep -hE '^\| `[A-Za-z0-9_.-]+` \|' "$C03" | sed -E 's/^\| `([A-Za-z0-9_.-]+)`.*/\1/' | grep -vE '^(FR|NFR|CON|CMP|UC|G)-' | sort -u)"
  d1="$(comm -23 <(echo "$code_mods") <(printf '%s\n%s\n' "$mapped" "$declared_non" | grep . | sort -u))"
  d2="$(comm -13 <(echo "$code_mods") <(echo "$mapped"))"
  [ -n "$d1" ] && bad "코드에 있으나 03 매핑표에 없다 (CMP 제안부터): $(echo "$d1" | join_lines)"
  [ -n "$d2" ] && bad "03 매핑표에 있으나 코드에 없다: $(echo "$d2" | join_lines)"
  [ -z "$d1$d2" ] && ok "최상위 모듈 $(echo "$code_mods" | grep -c .)개 — CMP $(echo "$mapped" | grep -c .)개 + 컴포넌트 아님 $(comm -12 <(echo "$code_mods") <(echo "$declared_non") | grep -c .)개"
fi

# ── 10. Mermaid 문법 (--mermaid) ───────────────────────────────────
if [ "${1:-}" = "--mermaid" ]; then
  section "Mermaid 문법 (로컬 브라우저)"
  mjs="${MERMAID_JS:-}"
  chrome="${CHROME:-}"
  if [ -z "$chrome" ]; then
    for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" "$(command -v google-chrome 2>/dev/null)" "$(command -v chromium 2>/dev/null)" "$(command -v chromium-browser 2>/dev/null)"; do
      [ -n "$c" ] && [ -x "$c" ] && { chrome="$c"; break; }
    done
  fi
  if [ -z "$mjs" ] || [ ! -f "$mjs" ]; then skip "MERMAID_JS=<mermaid.min.js 경로> 가 필요하다 (저장소는 이 파일을 들고 있지 않다)"
  elif [ -z "$chrome" ]; then skip "Chrome 계열 브라우저 없음 — CHROME=<실행 파일>"
  else
    work="$(mktemp -d "${TMPDIR:-/tmp}/check-diagrams.XXXXXX")"
    cp "$mjs" "$work/mermaid.min.js"
    # 문서를 그대로 실어 브라우저가 블록을 고른다 — 셸에서 따옴표 · 역슬래시를 다시 감싸지 않으려는 것
    {
      echo '<!doctype html><meta charset="utf-8"><body><pre id="result">PENDING</pre>'
      while IFS= read -r f; do
        [ -z "$f" ] && continue
        printf '<script type="text/plain" class="md" data-file="%s">\n' "${f#"$ROOT"/}"
        cat "$f"
        printf '\n</script>\n'
      done <<< "$md_files"
      cat <<'HTML'
<script src="mermaid.min.js"></script>
<script>
mermaid.initialize({ startOnLoad: false });
(async () => {
  const out = []; let total = 0, bad = 0;
  for (const el of document.querySelectorAll("script.md")) {
    const lines = el.textContent.split("\n"); let cur = null;
    for (let i = 0; i < lines.length; i++) {
      const l = lines[i];
      if (cur === null && /^```mermaid\s*$/.test(l)) cur = { line: i, code: [] };
      else if (cur !== null && /^```\s*$/.test(l)) {
        total++;
        try { await mermaid.render("m" + total, cur.code.join("\n")); }
        catch (e) { bad++; out.push("@@" + "BAD@@ " + el.dataset.file + ":" + cur.line + " — " + String((e && e.message) || e).replace(/\s+/g, " ").slice(0, 240)); }
        cur = null;
      } else if (cur !== null) cur.code.push(l);
    }
  }
  out.push("@@TOTAL@@ " + total + " " + bad);
  document.getElementById("result").textContent = out.join("\n");
})();
</script>
HTML
    } > "$work/index.html"
    dom="$("$chrome" --headless=new --disable-gpu --no-first-run --allow-file-access-from-files \
      --virtual-time-budget=60000 --dump-dom "file://$work/index.html" 2>/dev/null)"
    total_line="$(printf '%s\n' "$dom" | grep -o '@@TOTAL@@ [0-9]* [0-9]*' | head -1)"
    n_total="$(echo "$total_line" | awk '{print $2}')"; n_bad="$(echo "$total_line" | awk '{print $3}')"
    if [ -z "$total_line" ]; then bad "브라우저 결과를 읽지 못했다 (시간 부족이면 virtual-time-budget 을 늘린다)"
    elif [ "$n_bad" = "0" ]; then ok "Mermaid 블록 ${n_total}개 전부 그려진다"
    else bad "Mermaid 문법 오류 ${n_bad}건 (전체 ${n_total}):"$'\n'"$(printf '%s\n' "$dom" | grep -o '@@BAD@@ .*' | sed 's/^@@BAD@@ /    /')"
    fi
    if command -v trash >/dev/null; then trash "$work"; else echo "  (임시 폴더를 남겼다: $work)"; fi
  fi
fi

echo
echo "결과: 실패 ${fails} · 경고 ${warns}$([ "$is_skeleton" = 1 ] && echo ' · 골격 표식 있음(03)')"
[ "$fails" -eq 0 ]
