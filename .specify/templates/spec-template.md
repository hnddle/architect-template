<!--
  프로젝트 개정판 — 스펙킷 기본 spec-template 에 이 저장소가 실제로 쓴 절을 더했다.
  스펙킷을 업그레이드하면 이 파일이 덮일 수 있다. 덮였으면 git 이력에서 되살린다.
  자리표시 문법([FEATURE NAME] · [DATE] · $ARGUMENTS · [NEEDS CLARIFICATION: …])은 스킬이 읽으므로 그대로 둔다.
  형식 선택(정식 · 델타 · 경량 · 문서 단위 · 보류)은 specs/README.md. 경량이면 이 파일 대신 specs/_templates/spec-light.md 를 쓴다.
  ID 접두와 결정 번호 규칙은 .claude/rules/decisions. 결정 번호는 쓰기 직전에 specs/DECISIONS.md 에 범위를 먼저 잡는다.
-->
# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

| 항목 | 내용 |
| --- | --- |
| **기준 원문** | <날짜 · 소유자> 「원문을 바꿔 쓰지 않고 그대로」 — 번호가 있으면 ①② 그대로 |
| **상위 문서** | <SRS · PRD · C4 문서의 ID(FR · NFR · CMP · UC)와 앞 스펙 번호 · 결정 번호> |
| **결정 번호** | `D-<시작>` ~ `D-<끝>` (specs/DECISIONS.md 에 예약한 범위) |
| **데이터 이행** | `<이행 파일>` 또는 「없다 — 저장 구조를 바꾸지 않는다」 |
| **결정 주체** | <소유자 / 소유자 위임 — 구현자가 정하고 §결정에 남긴다. 바꾸려면 그 표를 고친다> |

## 이 문서의 위치

<!--
  정본 관계를 첫머리에 고정한다. 예:
  「상위 문서는 <SRS 경로> 다. 이 명세는 새 요구를 만들지 않는다 — 어긋나면 SRS 가 이긴다. 구조는 plan.md 가 맡는다.」
  델타 스펙이면: 「<베이스라인 스펙> 위에 얹는 델타 명세다. 개정 표시가 없는 곳에서 어긋나면 베이스라인이 이긴다.」
-->

<정본 관계 한두 문장>

## 용어

<!-- 소유자의 말과 승인 문서의 말이 다르면 여기서 하나로 고정한다. 폐지한 용어는 취소선 + 폐지 결정. -->

| 용어 | 정의 | 화면 표기 |
| --- | --- | --- |
| <용어> | <정의> | <화면에 보이는 글자> |

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.

  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  우선순위의 뜻을 한 문장으로 먼저 정한다(예: 「P1 = 이것이 없으면 흐름이 끊긴다」).

  시나리오는 testing.md 에 따라 **실패 시나리오를 먼저** 적는다(권한 없음 · 꺼진 기능 · 중복 요청 · 외부 실패 → 성공).
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [이 스토리가 없으면 무엇을 잃는가]

**Independent Test**: [이 스토리만으로 검증하는 방법 + 선행 스토리]

**Acceptance Scenarios**:

1. **Given** [권한이 없는 사용자], **When** [action], **Then** [거부와 다음 행동 안내]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  질문 → 답 → (근거 FR) 꼴로 쓴다. 지어낸 항목을 넣지 않는다 — 전부 FR 의 실패 동작에서 온다.
-->

- [경계 조건]이면? → [동작] (FR-00x)
- [오류 상황]이면? → [동작] (FR-00x)

## Requirements *(mandatory)*

<!--
  문형: 「시스템은 ~해야 한다」. 영역이 여럿이면 「영역 1 — …」 소제목으로 나눈다.
  줄 끝 괄호에 근거: *(US · 결정 · 결함 · 개정 대상 FR)*.
  결번은 줄을 지우지 않는다: 「~~FR-034~~: 결번 — <사유>. 번호를 재사용하지 않는다」.
  개정: **FR-005** *(개정 YYYY-MM-DD · D-0xx)*. 폐지: **FR-006** *(폐지 YYYY-MM-DD · D-0xx — 아래는 옛 문언)*: ~~옛 문언~~
-->

### Functional Requirements

- **FR-001**: 시스템은 [동작]해야 한다 *(US1 · D-0xx)*
- **FR-002**: 시스템은 [동작]해야 한다 *(US1)*
- **FR-003**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified]

### Non-Functional Requirements

<!-- 수치는 합격선이지 결론이 아니다 — 부하 시험 · 운영 실측으로 다시 정한다. -->

| ID | 품질 특성(ISO 25010) | 요구 | 합격선 · 근거 |
| --- | --- | --- | --- |
| NFR-001 | <보안성 · 신뢰성 …> | <요구> | <측정 가능한 기준 · 근거> |

### Key Entities *(include if feature involves data)*

<!-- 델타 스펙이면 베이스라인 대비 바뀌는 것만. -->

- **[Entity 1]**: [What it represents, key attributes without implementation]

## Success Criteria *(mandatory)*

<!--
  기술 불문 · 측정 가능. 하나라도 실패하면 출시하지 않는 지표에는 *(릴리스 실패 판정 지표)* 를 붙인다.
-->

### Measurable Outcomes

- **SC-001**: [수치 · 단위 · 판정 기준]
- **SC-002**: [Measurable metric] *(릴리스 실패 판정 지표)*

## Assumptions

<!-- 묶음으로 나눈다. 잠정이면 다시 정할 조건을 적는다. -->

- **판단으로 정한 것**: [가정 — 다시 정할 조건]
- **증거를 따라 정한 것**: [가정 — 근거]
- **이번 출시에서 빼기로 한 것**: [항목 — Out of Scope 로]
- **외부 의존과 환경**: [계약 · 키 · 외부 서비스]

## Out of Scope

<!--
  공통 원칙: 범위 밖 기능을 요청받으면 조용히 성공 처리하거나 빈 화면으로 두지 않고,
  제공하지 않는다는 사실을 화면(또는 응답 코드)에 드러낸다.
  행마다 이유와 「필요해지면 무엇을 더하면 되는지」를 함께 적는다.
-->

| 항목 | 이유 · 결정 | 필요해지면 |
| --- | --- | --- |
| <항목> | <이유 · D-0xx> | <더할 것> |

## 결정

<!--
  행 형식은 .claude/rules/decisions. 셀은 「**굵은 제목**: 본문」. 결정마다 버린 대안과 되돌리는 비용을 적는다.
  앞 결정을 뒤집으면 새 행 제목 뒤에 (D-0xx 대체), 옛 행은 지우지 않고 내용에 ~~…~~ → D-0yy 로 대체.
  결정이 헌법 원칙을 건드리면 개정 대상 칸에 「헌법 개정 필요」.
-->

| ID | 결정 | 근거 | 대안 · 버린 이유 | 되돌리는 비용 | 개정 대상 |
| --- | --- | --- | --- | --- | --- |
| D-0xx | **<제목>**: <본문> | <원문 · US · FR> | <대안 → 이유> | 낮음/중간/높음 — <이유> | <바뀌는 상위 FR · 문서 또는 없음> |

## 미결 사항 — 사람 확인 필요

<!--
  [NEEDS CLARIFICATION] 마커가 3개를 넘거나 사람만 정할 수 있는 것(계약 · 키 · 법무 · 금액)은 여기로.
  해소되면 행을 지우지 않는다: ~~항목~~ — **해소 YYYY-MM-DD (D-0xx)**. 결정 표에 들어간 것은 미결이 아니다.
-->

| ID | 항목 | 잠정값 | 정할 기한 | 근거 |
| --- | --- | --- | --- | --- |
| Q-0xx | <질문> | <지금 쓰는 값 또는 없음> | <G1 진입 전 · 법무 검토 뒤 …> | <FR · 원문> |

## 상위 스펙 보완 · 충돌 기록 *(델타 스펙만)*

<!--
  베이스라인 · 상위 문서와 어긋나는 곳. 상위 문서는 고치지 않는다(code-principles §1) — 처리 열 값은 셋 중 하나:
  D-0xx(결정으로 정함) / 「이 문서 결정」 / 「보고만」. 끝에 「n건 = 해소 a · 잠정 b · 보고만 c」 요약.
-->

| # | 상위 대상 | 빈틈 · 충돌 | 근거 | 처리 | 이 문서 위치 |
| --- | --- | --- | --- | --- | --- |
| SG-01 | <FR-0xx> | <내용> | <결함 ID · 코드 위치> | <D-0xx / 이 문서 결정 / 보고만> | <§> |

## Traceability

### FR → User Story

| FR | 주 담당 US(첫 등장) | 결정 |
| --- | --- | --- |
| FR-001 | US1 | D-0xx |

### 결정 → 요구

| 결정 | 바뀐 요구 |
| --- | --- |
| D-0xx | FR-001 |

### 커버리지 검사

<!-- 「빠짐없이」를 눈이 아니라 명령으로 확인한다. 결과를 checklists/requirements.md 의 Coverage 절에 적는다. -->

```bash
scripts/check-spec-coverage.sh specs/[###-feature-name]
# 상위 문서 ID 가 이 스펙에 전건 나오는지(범위 · 결번 지정):
scripts/check-spec-coverage.sh --ids FR 1 12 --skip 7 --in specs/[###-feature-name]/spec.md
```

## 개정 기록

<!--
  승인 뒤 바뀌면 본문을 다시 쓰지 않는다. 맨 위(머리 표 아래)에 배너를 붙이고 여기에 행을 더한다:
  > **개정 YYYY-MM-DD** — <한 줄>. 본문의 해당 문장은 이 표가 이긴다. 영향 받는 본문 줄: <§ · FR 목록>
  「결정 주체가 소유자이므로 미결이 아니다」 — 이 표의 행은 미결 표에 다시 올리지 않는다.
-->

| 날짜 | 결정 | 내용 | 바뀐 요구 |
| --- | --- | --- | --- |
| <YYYY-MM-DD> | D-0xx | <한 줄> | <FR-0xx 개정> |
