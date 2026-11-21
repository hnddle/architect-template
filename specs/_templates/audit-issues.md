<!--
  결함 목록 양식 — 결함 일괄 감사의 ② 단계. 영역 하나에 한 장.
  절차는 .claude/rules/workflow §8. 심각도는 critical(데이터 손실 · 권한 누출) · high(기능이 틀림) · medium · low. 복사해서 specs/NNN-<이름>/audit/issues-<영역>.md. 이 주석은 지운다.
  권고는 결정의 입력이지 결정이 아니다 — 결정은 오케스트레이터가 스펙 §결정에 내린다.
-->
# 결함 목록 — <영역 이름> (<영역 접두>)

기준 지도: `audit/map-<영역>.md` · 기준 커밋: <해시>

| 심각도 | 건수 |
| --- | --- |
| critical | <n> |
| high | <n> |
| medium | <n> |
| low | <n> |

---

## [critical] <접두>-01 (bug) — <파일>:<줄>; <파일>:<줄>

**Problem**: <사용자에게 무엇이 잘못 보이거나 일어나는가 — 한두 문장>

**Evidence**: <코드 인용 · grep 결과 · 재현 절차. 추측이면 「추측」이라고 적는다>

**Recommendation**: <고치는 방향 + 그 결함을 잡는 시험(실패 케이스)>

---

## [high] <접두>-02 (security) — <파일>:<줄>

**Problem**:

**Evidence**:

**Recommendation**:
