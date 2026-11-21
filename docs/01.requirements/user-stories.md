# 사용자 스토리 (User Stories)

> **문서 코드**: `USR` — 건수 · ID 범위는 [README §1](README.md#1-문서-지도)
> **원문**: <원문 §n> · [pain-points-root-causes.md](pain-points-root-causes.md) · [pain-points-impacts.md](pain-points-impacts.md)
> **연관**: [system-requirements.md](system-requirements.md) · [user-requirements.md](user-requirements.md)
> **작성일**: YYYY-MM-DD · **최종 개정**: YYYY-MM-DD

사용자 스토리는 **사용자가 원하는 바**를 `As a <역할>, I want <능력> so that <결과>`로 적고, 검증 가능한 Acceptance Criteria(AC)를 붙인 계층이다. Epic은 현행 워크플로우(`CWF`)의 Step과 대응한다.

<!-- 원자료에 스토리 서술이 없으면 아래 블록을 한 번만 두고 README §1 상태를 「✅ 승인 대기」로 적는다.
> **도출**: 원자료에는 스토리 형식의 서술이 없다. 아래 스토리는 원문의 요구 문장에서 AI가 역도출했으며, 각 스토리의 The Struggle에 원문 문장을 그대로 인용해 근거를 남긴다. **사용자 승인 대상**이다.
-->

---

<!-- Epic · Story 양식(파이프라인 단계 4-A). `### USR-n0m` 제목이 정의이고, Key Acceptance Criteria 번호 목록이 AC-k다.

## Epic 1 — <Epic 제목>

> **대응 단계**: `CWF-001` — <Step 제목> (Pain Point: `PNP-001`)
> 사업 요구 Epic이면: **대응 단계**: 없음 — 사용자 지시 YYYY-MM-DD

> **The Struggle**
> "<원문 인용>"
>
> **(요약)** <한 줄>

### USR-101 — <Story 제목 명사구>

| 항목 | 내용 |
| --- | --- |
| **주 Actor** | <역할> |
| **User Story** | As a <역할>, I want to <능력>, so that <결과>. |
| **Business Impact** | <원문 인용 · PNI-xxx · 사용자 지시 YYYY-MM-DD — "<원문>"> |

**Key Acceptance Criteria**

1. <검증 가능한 단일 조건>
2. <검증 가능한 단일 조건>

**파생 요구사항**: `REQ-xxx` · `REQ-xxx`
-->

<!-- 예시(회의실 예약):
### USR-201 — 겹치지 않는 예약

| 항목 | 내용 |
| --- | --- |
| **주 Actor** | 사내 사용자 |
| **User Story** | As a 사내 사용자, I want to 빈 시간에만 회의실 A를 예약하도록, so that 회의 시작 때 다른 팀과 마주치지 않는다. |
| **Business Impact** | `PNI-101` 회의 지연 · 취소 |

**Key Acceptance Criteria**

1. 이미 예약된 시간과 겹치는 예약은 저장되지 않는다.
2. 겹친 예약의 시간과 예약자가 화면에 표시된다.
-->

---

## 부록 A. Pain Point 대응 관계

| Story | 해소 대상 |
| --- | --- |

## 부록 B. 커버되지 않은 Pain Point

| Pain Point | 보완 출처 |
| --- | --- |

<!-- 예시: | `PNR-1xx` 용어 혼재 | 스토리가 아닌 **용어 결정** — [todo Q-NNN] | · | `PNA-1xx` 규모 · 속도 | 플랫폼 조건 — `SYS-5xx` | -->

---

요약 : <어느 Epic이 어느 축(자동화 · 다고객 수용 · 운영)을 맡는가 한 줄>
