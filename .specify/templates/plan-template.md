<!--
  프로젝트 개정판 — 스펙킷 기본 plan-template 에 이 저장소가 실제로 쓴 절을 더했다.
  스펙킷을 업그레이드하면 덮일 수 있다. 자리표시 문법([FEATURE] · [DATE] · [###-feature-name] · NEEDS CLARIFICATION)은 그대로 둔다.
  경량 형식이면 이 파일 대신 specs/_templates/plan-light.md.
-->
# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`
**Baseline**: <델타면 「<베이스라인 plan 경로> 위에 얹는 델타 계획 — 베이스라인 plan 은 고치지 않는다」, 아니면 지운다>

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

<!--
  한 문단 + 「기술 접근의 축은 n개다」 번호 목록 + 마지막 줄 「요약 : …」.
  첫 문장에 새 구조가 있는지 밝힌다(예: 「신설 컨테이너 · 컴포넌트 0건」).
-->

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. 스택은 헌법 「추가 제약」 표(ADR 로 채운다)를 따른다. 표가 비어 있으면 NEEDS CLARIFICATION 으로 두고
  스택 ADR 을 먼저 받는다 — 스택을 이 계획에서 임의로 고르지 않는다.
-->

**Language/Version**: [헌법 기술 스택 표의 값 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [프레임워크 · 주요 라이브러리 or NEEDS CLARIFICATION]  
**Storage**: [저장소 종류 — 스키마 정본 위치 + 이행 방식 or N/A]  
**Testing**: [시험 러너 · 실제 저장소를 띄우는 방법 or NEEDS CLARIFICATION]  
**Target Platform**: [실행 환경 · 지원 클라이언트 or NEEDS CLARIFICATION]
**Project Type**: [e.g., library · cli · web-service · mobile-app or NEEDS CLARIFICATION]  
**Performance Goals**: [domain-specific or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific or NEEDS CLARIFICATION]

NEEDS CLARIFICATION: <남은 건수 — research.md 에서 0건으로 만든다>

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

<!-- 원칙 번호는 .specify/memory/constitution.md 를 읽어 채운다. 두 열을 모두 채운다. -->

| # | 원칙 | 초기 평가 | 설계 후 재평가 |
| --- | --- | --- | --- |
| I | 승인된 문서가 정본이다 | <통과 · 근거> | <통과 · 근거> |
| II | 경계에서 판정한다 | | |
| III | 근거가 되는 기록은 고쳐 쓰지 않는다(선택) | <해당 없음 / 통과> | |
| IV | 재시도는 멱등 | | |
| V | 12-Factor · 벤더 비종속 | | |
| VI | 실패 케이스 우선 테스트 | | |
| VII | 의존은 안쪽으로 | | |

게이트 결과: <위반 없음 / 위반 n건 — Complexity Tracking 으로>

### 헌법과 저장소의 어긋남 (보고만)

<!--
  이 기능이 만든 위반이 아니라, 헌법 문장과 저장소의 현재 상태가 이미 다른 곳. 게이트를 막지 않는다.
  헌법 개정은 사람이 한다 — 여기에는 사실만 적는다. 없으면 「없음」.
-->

| 헌법 위치 | 저장소의 현재 상태 | 영향 | 제안 |
| --- | --- | --- | --- |
| <원칙 · 절> | <사실> | <이 기능에 미치는 영향> | <개정 제안 · 결정 번호> |

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

<!--
  ACTION REQUIRED: 바뀌는 파일만 적는다. 표시: + 신규 · ~ 수정 · → 이동 · − 삭제, 끝에 (담당 흐름).
  레이아웃은 CLAUDE.md 「저장소 지도」를 따른다. 아래는 모양만 보이는 예다.
-->

```text
<컨테이너 소스 루트>/<컴포넌트>/{domain,application,infrastructure,presentation}/...
  + <컴포넌트>/domain/<새 파일>                            (흐름 A)
  ~ <컴포넌트>/presentation/<고칠 파일>                    (흐름 A)
<스키마 정본>                                              (기반 단계에서 한 번)
<데이터 이행 파일>
```

**Structure Decision**: 컴포넌트 = 최상위 모듈 1:1(`.claude/rules/architecture-diagram/component-package-mapping`). 계층(domain · application · infrastructure · presentation)은 컴포넌트가 아니므로 최상위에 두지 않는다. [이 기능이 고른 위치와 이유]

## 1. 컴포넌트 → 패키지 매핑 (<n>/<n>)

<!-- 이 표에 없는 위치에 새 패키지를 만들지 않는다. 건수를 제목에 넣는다. -->

| CMP | 패키지 | 주 책임 | 담당 FR |
| --- | --- | --- | --- |
| <CMP-xxx> | `<모듈 이름>` | <책임> | <FR-00x> |

요약 : <한 줄>

## 2. NFR 구현 위치와 검증 수단

| NFR | 구현 위치 | 검증 수단(테스트 · 명령) |
| --- | --- | --- |
| NFR-001 | <클래스 · 설정> | <테스트 이름 · 명령> |

미커버 NFR: <0건>

## 3. 경계 강제 — 아키텍처 테스트 규칙

<!-- 문서가 아니라 테스트로 고정한다. 새 규칙이 없으면 「기존 AR-xx 그대로」. -->

| ID | 규칙 | 근거 |
| --- | --- | --- |
| AR-xx | <규칙> | <원칙 · NFR> |

## 4. 아키텍처 갭과 처리 방침

<!-- 상위 문서의 빈틈. 고치지 않고 구현이 막히지 않는 최소 선택만 제안한다. -->

| 갭 | 내용 | 처리 | 사람 결정 필요 |
| --- | --- | --- | --- |
| <갭> | <내용> | <최소 선택> | 예/아니오 |

## 5. 구현 단계 · 작업 흐름 · 파일 소유

<!--
  여러 에이전트가 병렬로 일할 때만 채운다. 혼자면 「단일 흐름」 한 줄.
  S0 문서 → S1 기반(공유 파일 · 흐름 사이 계약 고정) → S2 기능(병렬) → S3 통합.
  한 파일의 소유자는 한 단계에 한 흐름이다. 공유 파일(스키마 정본 · 빌드 설정 · 환경변수 견본 · 실행 구성)은 S1 에서 끝내거나 Edit 로 자기 구역만.
-->

| 흐름 | 소유 경로(겹치지 않음) | 맡는 스토리 |
| --- | --- | --- |
| A | <경로> | US1 |

### 흐름 사이 계약

| 제공 → 사용 | 시그니처 · 경로 | 고정 시점 |
| --- | --- | --- |
| A → B | <메서드 · API> | S1 끝 |

## 6. 검증 — Success Criteria 대응과 명령

| SC | 검증 수단 | 명령 |
| --- | --- | --- |
| SC-001 | <테스트 클래스 · E2E 단계> | `<명령>` |

## 7. 계획 결정 (PD-xx)

<!-- spec 의 D-n 과 구분되는 구현 수준 결정. 제품 동작이 바뀌면 PD 가 아니라 D 다. -->

| ID | 계획 결정 | 근거 |
| --- | --- | --- |
| PD-01 | <결정> | <근거> |

## 8. 위험 (RISK-xx)

<!-- 트레이드오프는 결정하지 않고 결정 주체를 적는다. -->

| ID | 위험 | 영향 | 대응 | 결정 주체 |
| --- | --- | --- | --- | --- |
| RISK-01 | <위험> | <영향> | <대응> | 사람(ATAM) / 결정됨(D-0xx) |

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified** — 구조를 늘리는 결정도 여기에 적는다.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 새 컴포넌트] | [current need] | [why the simpler option is insufficient] |

### 단순화로 남긴 상한

<!-- 일부러 단순하게 둔 곳과 그 상한 · 넘으면 바꿀 방법. 코드에는 ponytail: 주석으로 같은 내용을 남긴다(conventions.md). -->

| 위치 | 상한 | 넘으면 |
| --- | --- | --- |
| <모듈> | <예: 전체 잠금 하나 — 초당 n건까지> | <예: 회의실별 잠금> |

## 결정 커버리지

<!-- spec 의 결정 · 요구가 이 계획 어디에 반영됐는지. 빠짐은 명령으로 확인한다. -->

| 결정 · 요구 | 반영 절 |
| --- | --- |
| D-0xx | §1 · §5 |

```bash
scripts/check-spec-coverage.sh specs/[###-feature-name]
```

## 문서 갱신 제안 (이 작업에서 고치지 않음)

<!-- 하네스(CLAUDE.md · .claude/**) · 승인 문서 · README 에서 바뀌어야 할 곳. 없으면 「없음」. -->

- <파일 · 절> — <고칠 내용> (D-0xx)
