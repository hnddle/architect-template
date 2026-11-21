---

description: "Task list template for feature implementation (프로젝트 개정판)"
---

<!--
  프로젝트 개정판 — 스펙킷 기본 tasks-template 에 이 저장소가 실제로 쓴 절을 더했다.
  스펙킷을 업그레이드하면 덮일 수 있다. 태스크 줄 형식(- [ ] T001 [P] [US1] …)은 스킬이 검사하므로 그대로 둔다.
  경량 형식이면 tasks 를 따로 두지 않거나 plan-light 의 항목별 「시험」 줄로 대신한다.
-->

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/
**결정 정본**: spec.md §결정(D-0xx ~ D-0yy). 이 목록과 결정이 다르면 결정이 이긴다.
**Baseline**: <델타면 「<베이스라인 tasks> 는 고치지 않는다 — 델타 작업만」, 아니면 지운다>

**Tests**: **포함한다. 선택이 아니다**(헌법 원칙 VI — 스킬 안내의 「Tests are OPTIONAL」보다 헌법이 이긴다).

1. 시험 태스크가 같은 스토리의 구현 태스크보다 앞에 온다.
2. 시험 태스크 설명은 「실패 먼저:」(권한 없음 · 꺼진 기능 · 중복 요청 · 외부 실패 · 경계 위반) 다음 「성공:」 순서로 쓴다.
3. 빨간 시험만 따로 커밋하지 않는다 — 시험과 구현은 같은 커밋.
4. 저장 계층은 실제 저장소(일회용 시험 인스턴스)로. mock 은 외부 API 만.

**체크박스**: 진행 표시일 뿐 완료 판정이 아니다. 완료 판정은 각 단계의 `Checkpoint` 검증 명령과 시험 결과다. 체크는 `speckit-implement` 가 하거나 구현자가 같은 커밋에서 한다.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions
- 여러 흐름이 병렬이면 설명 앞에 흐름 이름: `- [ ] T012 [P] [US1] 흐름 A · …`
- 줄 끝 괄호는 근거: `(FR-003 · D-0xx)`. 선행은 `(선행 T010)` — `[P]` 와 함께면 「선행이 끝난 뒤 서로 병렬」.
- 오류는 오류 코드(`UPPER_SNAKE`)로 적는다 — 코드 표의 정본은 그 기능의 계약 문서(`contracts/`)다.

## Path Conventions

<!-- 줄임을 펼친 경로가 정확한 파일 경로다. 시험은 소스 구조를 거울처럼 둔다. 아래 표는 plan.md 의 구조 결정에 맞춰 채운다. -->

| 줄임 | 경로 |
| --- | --- |
| `src:` | `<컨테이너 소스 루트>/` |
| `test:` | `<그 컨테이너의 시험 루트>/` |
| `mig:` | `<데이터 이행 폴더>/` |

픽스처 값은 생성기 · 가짜 예시 값만 쓴다(`conventions.md`).

## 작업 흐름과 파일 소유 *(병렬일 때만)*

<!-- 한 파일의 소유자는 한 단계에 한 흐름이다. 단계가 바뀔 때만 소유가 넘어간다. plan.md §5 와 같게. -->

| 흐름 | 소유 경로 | 단계 |
| --- | --- | --- |
| A | <경로> | S2 |

## 문서 간 충돌과 이 문서의 선택 (보고)

<!-- spec · plan · contracts · data-model 이 서로 다르면 어느 쪽을 따랐는지. 결정 기록 · 계약이 계획 본문보다 구체적이면 그쪽. 스키마 정본은 data-model. 없으면 「없음」. -->

| # | 충돌 | 따른 쪽 | 이유 |
| --- | --- | --- | --- |
| 1 | <내용> | <문서> | <이유> |

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit-tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 [P] Add environment variable names to the env example file (값 없이 이름 · 설명만)

**Checkpoint**: 빌드 · 정적 검사 통과(명령은 CLAUDE.md 「명령」 표)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: 이 단계가 끝나기 전에는 어떤 User Story 도 시작하지 않는다. 공유 파일(스키마 정본 · 빌드 설정 · 실행 구성 · 환경변수 견본)과 흐름 사이 계약은 여기서 끝낸다.

- [ ] T003 Update the schema source of truth and add mig:<이행 파일> (멱등 · 추가만) (D-0xx)
- [ ] T004 [P] 실패 먼저: 이행을 두 번 적용해도 같은 결과 — test:<컴포넌트>/<이행 시험>
- [ ] T005 Fix interface signatures between flows in src:<컴포넌트>/application/<포트>

**Checkpoint**: Foundation ready — 전체 시험 녹색, 기준선 시험 수 이상

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (실패 케이스 우선) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T010 [P] [US1] 실패 먼저: 남의 기록 조회 → 없는 것과 같은 응답, 권한 없음 → 거부 — test:<컴포넌트>/<진입점 통합 시험> (FR-002)
- [ ] T011 [P] [US1] 실패 먼저: 같은 멱등 키 재전송 → 같은 기록 · 1건 — test:<컴포넌트>/<통합 시험> (FR-003)
- [ ] T012 [P] [US1] 성공: [user journey] — test:<컴포넌트>/<진입점 통합 시험> (FR-001)

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create [Entity] in src:<컴포넌트>/domain/<파일>
- [ ] T014 [US1] Implement [Service] in src:<컴포넌트>/application/<파일> (선행 T013)
- [ ] T015 [US1] Implement entry point in src:<컴포넌트>/presentation/<파일>
- [ ] T016 [P] [US1] Screen in <화면 소스 경로> + its test (화면이 있는 기능만)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently — `<검증 명령>`

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (실패 케이스 우선) ⚠️

- [ ] T020 [P] [US2] 실패 먼저: [실패 시나리오] — [test file path]
- [ ] T021 [P] [US2] 성공: [user journey] — [test file path]

### Implementation for User Story 2

- [ ] T022 [US2] Implement [Service] in [file path]

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX Run quickstart.md validation (시나리오 표 전 단계)
- [ ] TXXX [P] 함께 고칠 곳 점검 — 기능이 바뀌면 README · CLAUDE.md 결정 색인 · 용어집 · 소개 글. 하네스 파일이면 plan 「문서 갱신 제안」으로만
- [ ] TXXX 계획만 되고 만들지 않은 산출물이 없는지 확인 — 이 목록 · plan 이 산출물로 적은 파일이 모두 있는가
- [ ] TXXX 화면이 바뀌었으면 역할 × 화면 크기 전 화면 점검(`.claude/rules/testing.md` §5)
- [ ] TXXX 커버리지 검사: `scripts/check-spec-coverage.sh specs/[###-feature-name]`

---

## Success Criteria → 검증 태스크

| SC | 검증 태스크 | 판정 |
| --- | --- | --- |
| SC-001 | T012 · TXXX | <통과 기준> |

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable

### Within Each User Story

- Tests MUST be written and FAIL before implementation (실패 먼저 → 성공)
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- 흐름 사이 인계는 plan.md §5 「흐름 사이 계약」의 고정 시점을 따른다

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "실패 먼저: 남의 기록 조회 → 없는 것과 같은 응답 in test:<컴포넌트>/<진입점 통합 시험>"
Task: "실패 먼저: 같은 멱등 키 재전송 in test:<컴포넌트>/<통합 시험>"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery (게이트별)

| 게이트 | 끝난 것 | 확인 |
| --- | --- | --- |
| G2 | US1 | <명령> |
| G4 | 전 스토리 + 통합 | 전체 시험 녹색 · 기준선 이상 |

**측정 우선**: 성능 · 용량을 고치는 태스크는 먼저 측정 태스크를 두고, 측정값이 합격선을 넘을 때만 최적화한다.

---

## 범위 밖으로 남긴 결함 *(결함 일괄 수정일 때)*

| 결함 ID | 심각도 | 이유 |
| --- | --- | --- |
| <AREA-nn> | medium | <같은 원인 아님 · 다음 스펙> |

## 커버리지 검사

```bash
scripts/check-spec-coverage.sh specs/[###-feature-name]   # 태스크 형식 · ID · 결정 행 검사
```

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group — 커밋 subject 끝에 결정 번호 괄호 `(D-0xx)`
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
