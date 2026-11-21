# 사용자 요구사항 (User Requirements)

> **문서 코드**: `REQ` — 건수 · ID 범위는 [README §1](README.md#1-문서-지도)
> **원문**: [user-stories.md](user-stories.md) · [system-requirements.md](system-requirements.md) · [pain-points-root-causes.md](pain-points-root-causes.md) · [pain-points-amplifiers.md](pain-points-amplifiers.md) · [pain-points-impacts.md](pain-points-impacts.md) · [current-workflow.md](current-workflow.md)
> **연관**: [glossary.md](glossary.md) · [todo.md](todo.md)
> **작성일**: YYYY-MM-DD · **최종 개정**: YYYY-MM-DD

사용자 요구사항은 상위 계층 전부를 입력으로 받아 **독립적으로 검증할 수 있는 단일 의무**로 정립하는 경계점이다. 1 REQ = 1 의무. 근거 열의 **굵은 항목이 직접 출처**, 일반 항목이 보강 근거다. 구현 수단 · 릴리스 단계 · 우선순위는 쓰지 않는다. `PRD 영역` 열은 PRD 작성 후 채운다.

**범위 밖 (이 문서에 REQ를 두지 않음)**: <항목 · 항목>. 사유는 [todo.md](todo.md) §2.

---

<!-- 섹션 양식(파이프라인 단계 5). 정의 행의 ID 칸은 굵게(**REQ-001**) — 검사 스크립트가 굵은 첫 칸만 정의로 센다.

## 1. <핵심 질문>

> 대응 Pain Point: `PNR-1xx`(<별칭>) · `PNA-1xx`(<별칭>)

| REQ | 요구사항 | 근거 | PRD 영역 |
| --- | --- | --- | :---: |
| **REQ-001** | 시스템은 <단일 의무>. | **`USR-101 AC-1`** · `PNR-101` | <영역 번호 / 시스템 / 범위 밖> |
| ~~REQ-002~~ | (결번 — <원래 의무 요약>) YYYY-MM-DD (D-NNN) | — | 범위 밖 |
-->

<!-- 예시(회의실 예약):
## 1. 예약을 어떻게 확정하는가

> 대응 Pain Point: `PNR-1xx`(빈 줄 알았다)

| REQ | 요구사항 | 근거 | PRD 영역 |
| --- | --- | --- | :---: |
| **REQ-003** | 시스템은 같은 회의실에서 시간이 겹치는 예약을 저장하지 않아야 한다. | **`USR-201 AC-1`** · `PNR-101` | 1 |
-->

---

## 부록 A. SYS → REQ 대응

| SYS | 대응 REQ | 상태 |
| --- | --- | :---: |

## 부록 B. Pain Point 커버리지

| 문서 | 대응 / 전체 | 미대응 | 상태 |
| --- | --- | --- | :---: |

## 부록 C. 미해결 사항

| # | 사항 | 영향 REQ | 근거 | 상태 |
| --- | --- | --- | --- | --- |

## 부록 D. 결번 · 범위 밖

검증식의 「범위 밖」 칸은 이 표의 행 수다.

| REQ | 사유 | 일자 · 결정 | 대신 맡는 곳 |
| --- | --- | --- | --- |

## 부록 E. PRD 기능 영역 배분

정본은 `PRD` §13.1이다. 각 REQ의 배분 결과는 본문 `PRD 영역` 열에 있다. 이 열은 **배분 결과 표기이지 REQ의 근거가 아니다** — PRD를 REQ의 근거로 인용하지 않는다.

| 구분 | 기능 영역 | 기능 | REQ 수 |
| --- | --- | :---: | ---: |

<!-- 숫자를 채우면 scripts/check-requirements.sh 가 다시 센다. 고칠 때 지난 식은 괄호에 이력으로: 검증식: 40 + 8 + 2 = 50 (이전 30 + 6 + 1 = 37) -->
검증식: <제품 기능> + <시스템> + <범위 밖> = <REQ 총수>

> REQ 섹션 번호와 PRD 영역 번호는 대응하지 않는다 — PRD 영역은 REQ의 카테고리가 아니라 성격에서 도출한다.

---

요약 : <어느 섹션이 제품의 축이고 어느 섹션이 플랫폼 조건인가 한 줄>
