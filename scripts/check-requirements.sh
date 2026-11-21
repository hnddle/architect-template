#!/usr/bin/env bash
# 요구공학 산출물(docs/00~03)과 요구공학 규칙의 기계 검사 — 파일을 읽기만 한다.
#
# 쓰는 법: bash scripts/check-requirements.sh [저장소 루트]
# 규칙의 정본: .claude/rules/requirements-engineering/requirements-pipeline 단계 8
#
# 검사
#   1. ID 연속성 — 코드마다 1부터 끊김 없이(카테고리 채번은 백의 자리마다). 결번은 취소선 ID(~~REQ-001~~)로 모은다
#   2. 미정의 참조 — 문서에 적힌 ID · USR AC-k · Q-n 이 정의(또는 결번)되어 있는가
#   3. FR/NFR 10필드 순서 · 기능 설명 3~7 · AC 2~5 · Related Requirements 존재
#   4. 금지 문체 — FR/NFR 제목의 서술형, 본문의 합니다/됩니다, 주관 부사(REQ 행 포함)
#   5. 역색인 — 활성 REQ 가 FR/NFR 에 연결되는가 · SYS 가 REQ 문서에 대응되는가 · USR 에 파생 요구사항이 있는가
#   6. 건수 — README §1 문서 지도의 「건수」 칸 = 실제 정의 수, `검증식:` 줄의 더하기와 REQ 총수
#   7. 링크 — 요구 문서와 요구공학 규칙의 상대 링크가 실제 파일을 가리키는가
#
# HTML 주석(<!-- -->)과 코드 블록(```) 안은 세지 않는다 — 골격의 예시는 주석 안에 둔다.
# 실패가 하나라도 있으면 1 로 끝난다.

set -u
# awk 를 바이트 단위로 돌린다 — 한글이 든 줄에서 UTF-8 모드 awk 가 문자 변환에 실패하며 멈추는 일을 막는다. ID · 표지는 모두 ASCII 라 결과는 같다.
export LC_ALL=C

ROOT="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
REQ_DIR="$ROOT/docs/01.requirements"
PRD_DIR="$ROOT/docs/02.prd"
SRS_DIR="$ROOT/docs/03.srs"

if [ ! -d "$REQ_DIR" ]; then
  printf '✗ %s 가 없다\n' "$REQ_DIR"
  exit 1
fi

# HTML 주석과 코드 블록을 빈 줄로 바꾼다(줄 번호는 유지).
STRIP_AWK='
function strip_line(s,   out, i) {
  out = ""
  while (length(s) > 0) {
    if (incomment) {
      i = index(s, "-->")
      if (i == 0) return out
      s = substr(s, i + 3); incomment = 0
    } else {
      i = index(s, "<!--")
      if (i == 0) return out s
      out = out substr(s, 1, i - 1); s = substr(s, i + 4); incomment = 1
    }
  }
  return out
}
{
  if (!incomment && $0 ~ /^[ \t]*(```|~~~)/) { infence = !infence; print ""; next }
  if (infence) { print ""; next }
  print strip_line($0)
}'

stream() {
  local f
  for f in "$@"; do
    [ -f "$f" ] || continue
    printf '@@FILE %s\n' "${f#"$ROOT"/}"
    awk "$STRIP_AWK" "$f"
  done
}

# ponytail: 이름 순 마지막 prd-v*.md 를 현재 판으로 본다. prd-v10 이상이 생기면 버전 정렬로 바꾼다.
PRD_FILE=""
for f in "$PRD_DIR"/prd-v*.md; do [ -f "$f" ] && PRD_FILE="$f"; done
PRD_NAME="$(basename "${PRD_FILE:-none}")"

DOC_FILES=()
for f in "$REQ_DIR"/*.md "$SRS_DIR"/*.md; do [ -f "$f" ] && DOC_FILES+=("$f"); done
[ -n "$PRD_FILE" ] && DOC_FILES+=("$PRD_FILE")

# 미결 Q-NNN 은 저장소 전역 번호다(.claude/rules/decisions) — 스펙의 「미결 사항」 표 첫 칸에 정의된 것도 인정한다.
QEXTRA="$(cat "$ROOT"/specs/*/*.md 2>/dev/null | grep -oE '^\| *[*`]*Q-[0-9]+' | grep -oE 'Q-[0-9]+' | sort -u | tr '\n' ' ')"

# ---------------------------------------------------------------- 1~6: 문서 검사
stream ${DOC_FILES[@]+"${DOC_FILES[@]}"} | awk -v prdname="$PRD_NAME" -v qextra="$QEXTRA" '
function err(msg)  { printf "✗ %s:%d %s\n", fpath, lnum, msg; errors++ }
function errg(msg) { printf "✗ %s\n", msg; errors++ }
function trim(s)   { gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s); return s }
function idcode(id) { return substr(id, 1, index(id, "-") - 1) }
function idnum(id)  { return substr(id, index(id, "-") + 1) + 0 }
function cell(s, k,   a, n) { n = split(s, a, "|"); return (k + 1 <= n) ? trim(a[k + 1]) : "" }
function ncells(s,   t) { t = s; return gsub(/\|/, "", t) - 1 }
function lastcell(s,   a, n, i) { n = split(s, a, "|"); for (i = n; i >= 1; i--) if (trim(a[i]) != "") return trim(a[i]); return "" }
function bare(s) { gsub(/[*`]/, "", s); return trim(s) }
function define(id) {
  if (id in def) err(id " 중복 정의 (처음 " def[id] ")")
  else { def[id] = fpath ":" lnum; ndef[idcode(id)]++ }
}
function retire(id) { if (!(id in ret)) { ret[id] = fpath ":" lnum; nret[idcode(id)]++ } }
function ownfile(code) {
  if (code == "CWF") return "current-workflow.md"
  if (code == "FDW") return "concurrent-workload.md"
  if (code == "PNP") return "pain-points.md"
  if (code == "PNR") return "pain-points-root-causes.md"
  if (code == "PNA") return "pain-points-amplifiers.md"
  if (code == "PNI") return "pain-points-impacts.md"
  if (code == "USR") return "user-stories.md"
  if (code == "SYS") return "system-requirements.md"
  if (code == "REQ") return "user-requirements.md"
  if (code == "PRD") return prdname
  if (code == "FR")  return "srs_03"
  if (code == "NFR") return "srs_04"
  return ""
}
function isown(code,   o) { o = ownfile(code); return (fname == o || (o ~ /^srs_0/ && index(fname, o "_") == 1)) }
function end_block(   i, ok, list) {
  if (!inblk) return
  ok = (nh == nexp)
  for (i = 1; ok && i <= nexp; i++) if (H[i] != EXP[i]) ok = 0
  if (!ok) {
    list = ""
    for (i = 1; i <= nh; i++) list = list (i > 1 ? " · " : "") H[i]
    printf "✗ %s %s 필드 순서가 10필드와 다름 — 지금: %s\n", bloc, bid, list; errors++
  }
  if (!titleseen) { printf "✗ %s %s 제목 줄(**…**) 없음\n", bloc, bid; errors++ }
  if (nbul < 3 || nbul > 7) { printf "✗ %s %s 기능 설명 불릿 %d개 (3~7)\n", bloc, bid, nbul; errors++ }
  if (nac < 2 || nac > 5)   { printf "✗ %s %s Acceptance Criteria %d개 (2~5)\n", bloc, bid, nac; errors++ }
  if (nrel == 0)            { printf "✗ %s %s Related Requirements 에 REQ 없음\n", bloc, bid; errors++ }
  inblk = 0
}
BEGIN {
  ncodes = split("CWF FDW PNP PNR PNA PNI USR SYS REQ PRD FR NFR", CODE, " ")
  for (i = 1; i <= ncodes; i++) iscode[CODE[i]] = 1
  split("PNR PNA PNI USR SYS PRD", C, " "); for (i in C) iscat[C[i]] = 1
  nexp = split("목적|기능 설명|Acceptance Criteria|예외 사항|상세|의존성|Related Requirements|확인 필요", EXP, "|")
  nq = split(qextra, QX, " "); for (i = 1; i <= nq; i++) qdef[QX[i]] = "specs"
  ADV = "(안전하게|완벽하게|원활히|원활하게|정상적으로|적절히|빠르게|유연하게|직관적으로|최대한|가능한 한|필요 시)"
}
/^@@FILE / {
  end_block()
  fpath = substr($0, 8); fname = fpath; sub(/.*\//, "", fname)
  lnum = 0; inappendix = 0; cur = ""; inac = 0
  ismap = (fpath ~ /01\.requirements\/README\.md$/); if (ismap) sawmap = 1
  next
}
{ lnum++; line = $0 }

# ---- 결번: 자기 문서의 취소선 제목 · 첫 칸
/^#+ ~~[A-Z]+-[0-9][0-9][0-9]~~/ {
  if (match(line, /[A-Z]+-[0-9][0-9][0-9]/)) { id = substr(line, RSTART, RLENGTH); if (iscode[idcode(id)] && isown(idcode(id))) retire(id) }
}
/^\|/ {
  c = bare(cell(line, 1))
  if (c ~ /^~~[A-Z]+-[0-9][0-9][0-9]~~$/) { id = substr(c, 3, length(c) - 4); if (iscode[idcode(id)] && isown(idcode(id))) retire(id) }
}

# ---- 정의
fname == "current-workflow.md"  && match(line, /^`CWF-[0-9][0-9][0-9]`/) { define(substr(line, 2, RLENGTH - 2)) }
fname == "concurrent-workload.md" && match(line, /^`FDW-[0-9][0-9][0-9]`/) { define(substr(line, 2, RLENGTH - 2)) }
fname == "pain-points.md"       && match(line, /^`PNP-[0-9][0-9][0-9]`/) { define(substr(line, 2, RLENGTH - 2)) }
(fname == "pain-points-root-causes.md" || fname == "pain-points-amplifiers.md" || fname == "pain-points-impacts.md") && /^\|/ {
  c = bare(cell(line, 1))
  if (c ~ /^PN[RAI]-[0-9][0-9][0-9]$/ && isown(idcode(c)) && ncells(line) >= 3) define(c)
}
fname == "system-requirements.md" && /^\|/ {
  c = bare(cell(line, 1)); if (c ~ /^SYS-[0-9][0-9][0-9]$/ && ncells(line) >= 4) define(c)
}
fname == "user-stories.md" {
  if (match(line, /^### USR-[0-9][0-9][0-9]/)) { cur = substr(line, 5, 7); define(cur); inac = 0 }
  else if (line ~ /^\*\*Key Acceptance Criteria\*\*/) inac = 1
  else if (line ~ /^(#|\*\*파생)/) inac = 0
  else if (inac && line ~ /^[0-9]+\. /) ac[cur]++
  if (line ~ /^\*\*파생 요구사항\*\*/ && line ~ /REQ-[0-9][0-9][0-9]/ && cur != "") derived[cur] = 1
}
fname == "user-requirements.md" {
  if (line ~ /^## 부록/) inappendix = 1
  if (!inappendix && match(line, /^\| *\*\*REQ-[0-9][0-9][0-9]\*\* *\|/)) {
    id = bare(cell(line, 1)); define(id)
    if (lastcell(line) ~ /범위 밖/) outscope[id] = 1
    if (line ~ ADV) err(id " 주관 부사")
  }
}
fname == prdname && match(line, /^#### PRD-[0-9][0-9][0-9]/) { define(substr(line, 6, 7)) }
fname == "todo.md" && /^\|/ { c = bare(cell(line, 1)); if (c ~ /^Q-[0-9]+$/) qdef[c] = fpath ":" lnum }

# ---- FR / NFR 블록
(fname ~ /^srs_0[34]_/) && (line ~ /^# / || line ~ /^## /) { end_block() }
(fname ~ /^srs_03_/ && line ~ /^## FR-[0-9][0-9][0-9] *$/) || (fname ~ /^srs_04_/ && line ~ /^## NFR-[0-9][0-9][0-9] *$/) {
  bid = trim(substr(line, 4)); define(bid); nblocks++
  inblk = 1; bloc = fpath ":" lnum; titleseen = 0; nh = 0; sec = ""; nbul = 0; nac = 0; nrel = 0
  next
}
inblk {
  if (line ~ /^### /) { sec = trim(substr(line, 5)); H[++nh] = sec; next }
  if (!titleseen && trim(line) != "") {
    titleseen = 1
    if (line !~ /^\*\*.+\*\* *$/) { err(bid " 제목 줄은 **명사구** 형식"); }
    else if (line ~ /(해야 한다|할 수 있다)/) err(bid " 제목이 서술형")
    if (line ~ ADV) err(bid " 제목에 주관 부사")
    next
  }
  if (line ~ /(합니다|됩니다|습니다)/) err(bid " 본문 금지 어미(합니다 · 됩니다)")
  if (line ~ ADV) err(bid " 주관 부사")
  if (sec == "기능 설명" && line ~ /^- /) nbul++
  if (sec == "Acceptance Criteria" && line ~ /^- \[[ xX]\]/) nac++
  if (sec == "Related Requirements") {
    s = line
    while (match(s, /REQ-[0-9][0-9][0-9]/)) { rel[substr(s, RSTART, RLENGTH)] = 1; nrel++; s = substr(s, RSTART + RLENGTH) }
  }
}

# ---- 참조 수집
{
  s = line
  while (match(s, /(CWF|FDW|PNP|PNR|PNA|PNI|USR|SYS|REQ|PRD|NFR|FR)-[0-9][0-9][0-9]/)) {
    id = substr(s, RSTART, RLENGTH); pre = (RSTART > 1) ? substr(s, RSTART - 1, 1) : ""; post = substr(s, RSTART + RLENGTH, 1)
    if (pre !~ /[A-Za-z]/ && post !~ /[0-9]/) {
      if (!(id in ref)) ref[id] = fpath ":" lnum
      if (fname == "user-requirements.md") inreqdoc[id] = 1
    }
    s = substr(s, RSTART + RLENGTH)
  }
  s = line
  while (match(s, /USR-[0-9][0-9][0-9] AC-[0-9]+/)) {
    t = substr(s, RSTART, RLENGTH); k = substr(t, index(t, "AC-") + 3) + 0; u = substr(t, 1, 7)
    if (!((u SUBSEP k) in acref)) acref[u SUBSEP k] = fpath ":" lnum
    s = substr(s, RSTART + RLENGTH)
  }
  s = line
  while (match(s, /Q-[0-9]+/)) {
    pre = (RSTART > 1) ? substr(s, RSTART - 1, 1) : ""; post = substr(s, RSTART + RLENGTH, 1)
    if (pre !~ /[A-Za-z0-9]/ && post !~ /[A-Za-z]/) { q = substr(s, RSTART, RLENGTH); if (!(q in qref)) qref[q] = fpath ":" lnum }
    s = substr(s, RSTART + RLENGTH)
  }
}

# ---- 문서 지도 · 검증식
ismap && /^## / { inmapsec = (line ~ /^## 1\./) }
ismap && inmapsec && /^\|/ {
  code = bare(cell(line, 3)); n = trim(cell(line, 5))
  if (iscode[code]) {
    mapseen[code] = 1
    if (n ~ /^[0-9]+$/) { mapc[code] = n + 0; mapl[code] = fpath ":" lnum }
    else err("문서 지도 " code " 행의 건수 칸은 숫자만 (지금: " n ")")
  }
}
/검증식:/ {
  s = substr(line, index(line, "검증식:"))
  if (match(s, /[0-9]+( *\+ *[0-9]+)+ *= *[0-9]+/)) {
    eq = substr(s, RSTART, RLENGTH); split(eq, side, "="); np = split(side[1], parts, "+")
    sum = 0; for (i = 1; i <= np; i++) sum += trim(parts[i]) + 0
    rhs = trim(side[2]) + 0
    if (sum != rhs) err("검증식 더하기가 틀림: " eq)
    neq++; eqv[neq] = rhs; eql[neq] = fpath ":" lnum
  }
}

END {
  end_block()
  if (!sawmap) errg("docs/01.requirements/README.md 문서 지도가 없다")

  # 1. 연속성
  for (id in def) { c = idcode(id); n = idnum(id); have[c SUBSEP n] = 1; if (n > maxn[c]) maxn[c] = n }
  for (id in ret) { c = idcode(id); n = idnum(id); if (id in def) errg(id " 정의와 결번에 동시에 있음 (" def[id] " · " ret[id] ")"); have[c SUBSEP n] = 1; if (n > maxn[c]) maxn[c] = n }
  for (i = 1; i <= ncodes; i++) {
    c = CODE[i]
    if (!maxn[c]) continue
    if (iscat[c]) {
      for (key in have) { split(key, kk, SUBSEP); if (kk[1] != c) continue; h = int(kk[2] / 100); lo = kk[2] % 100
        if (lo == 0) errg(sprintf("%s-%03d 일련번호 00 은 쓰지 않는다", c, kk[2]))
        if (lo > hmax[c SUBSEP h]) hmax[c SUBSEP h] = lo
        if (h > topcat[c]) topcat[c] = h }
      for (h = 1; h <= topcat[c]; h++) {
        if (!hmax[c SUBSEP h]) { errg(sprintf("%s-%dxx 카테고리가 비었다 (백의 자리는 1부터 이어 쓴다)", c, h)); continue }
        for (n = 1; n <= hmax[c SUBSEP h]; n++) if (!((c SUBSEP (h * 100 + n)) in have)) errg(sprintf("%s-%03d 이 없다 — 지웠으면 취소선 결번으로 남긴다", c, h * 100 + n))
      }
    } else {
      for (n = 1; n <= maxn[c]; n++) if (!((c SUBSEP n) in have)) errg(sprintf("%s-%03d 이 없다 — 지웠으면 취소선 결번으로 남긴다", c, n))
    }
  }

  # 2. 미정의 참조
  for (id in ref) if (!(id in def) && !(id in ret)) errg(ref[id] " " id " 는 정의되지 않았다")
  for (key in acref) { split(key, kk, SUBSEP); u = kk[1]; k = kk[2] + 0
    if (!(u in def)) continue
    if (k < 1 || k > ac[u] + 0) errg(acref[key] " " u " AC-" k " 이 없다 (AC " ac[u] + 0 "개)") }
  for (q in qref) if (!(q in qdef)) errg(qref[q] " " q " 는 todo.md §1 · specs 미결 표 어디에도 없다")

  # 5. 역색인
  if (ndef["FR"] + ndef["NFR"] > 0)
    for (id in def) if (idcode(id) == "REQ" && !(id in outscope) && !(id in rel)) errg(def[id] " " id " 가 어느 FR/NFR 의 Related Requirements 에도 없다")
  if (ndef["REQ"] > 0) {
    for (id in def) if (idcode(id) == "SYS" && !(id in inreqdoc)) errg(def[id] " " id " 가 user-requirements.md(부록 A)에 대응되지 않았다")
    for (id in def) if (idcode(id) == "USR" && !(id in derived)) errg(def[id] " " id " 에 파생 요구사항(REQ) 줄이 없다")
  }

  # 6. 건수
  for (i = 1; i <= ncodes; i++) {
    c = CODE[i]; n = ndef[c] + 0
    if (!(c in mapc)) { if (sawmap && !(c in mapseen)) errg("README §1 문서 지도에 " c " 행이 없다"); continue }
    if (mapc[c] != n) errg(mapl[c] " 문서 지도 " c " 건수 " mapc[c] " ≠ 실제 " n)
  }
  reqtotal = ndef["REQ"] + nret["REQ"]
  for (i = 1; i <= neq; i++) if (reqtotal > 0 && eqv[i] != reqtotal) errg(eql[i] " 검증식 합계 " eqv[i] " ≠ REQ 총수 " reqtotal " (활성 " ndef["REQ"] + 0 " + 결번 " nret["REQ"] + 0 ")")

  # 결번 목록 · 요약
  for (id in ret) { c = idcode(id); rlist[c] = rlist[c] " " id }
  printf "· 정의 수:"
  for (i = 1; i <= ncodes; i++) printf " %s %d", CODE[i], ndef[CODE[i]] + 0
  printf "\n"
  for (i = 1; i <= ncodes; i++) if (rlist[CODE[i]] != "") printf "· 결번 %s:%s\n", CODE[i], rlist[CODE[i]]
  exit (errors > 0)
}'
doc_status=$?

# ---------------------------------------------------------------- 7: 링크
LINK_FILES=()
for f in "$ROOT"/docs/00.project-proposal/*.md "$REQ_DIR"/*.md "$PRD_DIR"/*.md "$SRS_DIR"/*.md \
         "$ROOT"/.claude/rules/requirements-engineering/* "$ROOT"/.claude/rules/writing-style; do
  [ -f "$f" ] && LINK_FILES+=("$f")
done

link_status=0
while IFS="$(printf '\t')" read -r src target; do
  [ -n "$src" ] || continue
  if [ ! -e "$ROOT/$(dirname "$src")/$target" ]; then
    printf '✗ %s 깨진 링크 → %s\n' "$src" "$target"
    link_status=1
  fi
done < <(stream ${LINK_FILES[@]+"${LINK_FILES[@]}"} | awk '
  /^@@FILE / { f = substr($0, 8); next }
  {
    s = $0; gsub(/`[^`]*`/, "", s)
    while (match(s, /\]\([^)]*\)/)) {
      t = substr(s, RSTART + 2, RLENGTH - 3); s = substr(s, RSTART + RLENGTH)
      if (t ~ /^(https?:|mailto:|#)/ || t ~ /[<> ]/ || t == "") continue
      sub(/#.*/, "", t); if (t != "") printf "%s\t%s\n", f, t
    }
  }')

if [ "$doc_status" -eq 0 ] && [ "$link_status" -eq 0 ]; then
  printf '✓ 요구 문서 검사 통과 (%d개 문서 · 링크 %d개 파일)\n' "${#DOC_FILES[@]}" "${#LINK_FILES[@]}"
  exit 0
fi
printf '요구 문서 검사 실패\n'
exit 1
