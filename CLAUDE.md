# CLAUDE.md

이 파일은 이 저장소에서 일하는 Claude Code 의 상시 지침이다. 정본 문서를 가리키는 색인이고, 규칙 본문은 `.claude/rules/` 에 있다.

<!-- SPECKIT START -->
활성 기능의 계획: 아직 없음 (`speckit-plan` 이 이 줄을 `specs/<NNN>-<이름>/plan.md` 로 바꾼다)
<!-- SPECKIT END -->

## 이 프로젝트

> 템플릿을 복사한 뒤 소유자가 채운다. 남은 `<…>` 빈칸은 `scripts/check-leaks.sh` 가 알린다.

- **한 줄 정의**: <누구의 무슨 일을 무엇으로 바꾸는 제품인가>
- **산출물 형태**: <웹 서비스 | 모바일 앱 | CLI | 라이브러리 | …>
- **기획 원문**: `docs/00.project-proposal/`. 고객 · 현업이 넘긴 자료와 참고 시스템은 관찰 자료다(그대로 다시 만드는 대상이 아니다). 소유자가 직접 쓴 기획서는 소유자 지시다 — 확정 결정은 `D-NNN` 으로 옮기고 번호는 `기획 FR-18` 처럼 인용한다(`source-intake` §1.1).
- **기술 스택**: 미정. 이 템플릿은 언어 · 프레임워크 · 인프라를 정하지 않는다. SRS 승인 뒤 ADR 로 고르고 헌법 기술 스택 표와 아래 「명령」 · 「저장소 지도」를 채운다. **스택이 정해지기 전에는 구현 코드를 쓰지 않는다.**
- **운영 모드**: B(1인 로컬). A(팀 · 브랜치 + PR)로 바꾸려면 `git-workflow.md` 를 따른다. 적지 않으면 B 다.
- **예시 도메인**: 문서 곳곳의 「샘플서비스(공유 회의실 예약)」는 양식을 보여 주는 견본이다. 실제 내용으로 바꾸며 지운다.

## 저장소 지도

```
docs/
  00.project-proposal/   기획 원문과 원자료 정리(사실 · 판단 · 질문을 나눈다)
  01.requirements/       현행 업무 → 고통 → 분석 → 사용자 스토리 · 시스템 요구 → REQ
  02.prd/                REQ 를 기능 영역 · 릴리스로 묶은 제품 요구사항 정의서
  03.srs/                FR · NFR (원자적 기능의 최종 상태) — 설계의 입력
  04.design/             C4(Context · Container · Component) · UC · Activity · 배포 · DFD · 시퀀스 · ADR
specs/                   기능 단위 스펙 <NNN>-<이름>/ · DECISIONS.md(번호 레지스트리) · _templates/
scripts/                 문서 검사(bash 만 쓴다)
.claude/rules/           구속 규칙 · .claude/skills/ Spec Kit 스킬 · .specify/ 헌법과 양식
<코드>                   스택을 고른 뒤 정한다 — 컨테이너 하나 = 빌드 단위 하나, 컴포넌트 하나 = 최상위 모듈 하나
```

컴포넌트와 코드 모듈은 1:1이다(`docs/04.design/01.architecture/01.diagram/03_c4_component.md` 매핑표가 정본 — 코드 · 매핑표 · 아키텍처 검사를 같은 변경에서 함께 고친다).

## 명령

| 대상 | 명령 |
| --- | --- |
| 요구 문서 검사 | `scripts/check-requirements.sh` — ID 연속성 · 미정의 참조 · FR 10필드 · AC 개수 · 금지 문체 · 건수 · 링크 |
| 설계 문서 검사 | `scripts/check-diagrams.sh` — CON · CMP · UC · 액터 집합 · FR 커버리지 · 링크 · Mermaid 블록. `--mermaid`(선택, `MERMAID_JS` · `CHROME`) · `CODE_ROOTS=<소스 루트>`(코드 모듈 ↔ 매핑표) |
| 스펙 검사 | `scripts/check-spec-coverage.sh [specs/<NNN>-x]` — 결번 · 결정 칸 · 번호 레지스트리 |
| 예시 · 빈칸 · 누출 | `scripts/check-leaks.sh [--terms <저장소 밖 파일>] [--strict] [--list]` |
| 빌드 · 시험 · 실행 · 정적 검사 | <스택을 고른 뒤 채운다 — 단위 시험과 통합 시험을 따로 돌리는 명령 포함> |

## 작업 흐름

```
기획 원문 → 원자료 정리(0) → 제품 정의(0.5) → 요구 도출(1~5: CWF → PNP → PNR/PNA/PNI → USR/SYS → REQ)
        → PRD(6) → SRS(7: FR · NFR) → 설계(C4 → UC → Activity → 배포) → 스택 ADR
        → 스펙(specify → clarify → plan → tasks) → 구현 → 리뷰 → QA
```

- 위에서 아래로만 흐른다. 아래 단계에서 새 사실이 나오면 위 문서부터 고치고 다시 내려온다. **단계마다 사람 검토가 게이트다.**
- 요구 단계의 규칙은 `requirements-engineering/requirements-pipeline`, 설계 단계는 `architecture-diagram/diagram-workflow`, 스펙 이후(9단계 · 게이트 G1~G5 · 서브에이전트 · 동시 세션 · 보고 형식)는 `workflow` 가 정본이다.
- Spec Kit: `speckit-specify` → `speckit-clarify` → `speckit-plan` → `speckit-tasks` → `speckit-implement`. 스펙 형식(정식 · 델타 · 경량 · 문서 단위) 고르기는 `specs/README.md` §2.
- 헌법 `.specify/memory/constitution.md` 의 상태는 Version 줄이 정본이다. tasks 스킬의 「Tests are OPTIONAL」은 헌법 VI 가 이긴다 — 시험은 늘 넣는다.
- 모드 B 기본값: 스펙을 만들 때 브랜치를 만드는 훅이 꺼져 있고(`.specify/extensions.yml` 의 `before_specify`), 자동 커밋도 꺼져 있다(`.specify/extensions/git/git-config.yml` 의 `auto_commit`). 활성 스펙은 `SPECIFY_FEATURE_DIRECTORY` → `.specify/feature.json` → 브랜치 이름 순으로 정해진다.
- 다이어그램은 **Mermaid 가 1차**다(문서 안 블록이 정본). 발표 · 검토용으로 다듬은 그림이 필요하면 archify 같은 렌더 플러그인을 추가로 쓸 수 있다 — 그때도 정본은 Mermaid 다.

## 결정 색인

이 프로젝트의 결정이 생기면 한 줄씩 더한다(하네스 수정 금지의 예외 — 이 표의 새 행과 위 SPECKIT 블록만). 형식은 `| 항목 | 지금 | 근거(스펙 · D-nnn) |`, 행당 300자 이하, 상세는 스펙 §결정에 둔다. 이 파일 예산은 20KB(`wc -c`) — 넘치면 오래된 행을 `docs/decision-index.md` 로 옮긴다. 번호 잡기 · 대체 표기 · 헌법과 부딪칠 때는 `.claude/rules/decisions`.

| 항목 | 지금 | 근거 |
| --- | --- | --- |

**아직 사람 확인이 필요한 것**: 없음. `specs/DECISIONS.md` 「열린 보고만 · 사람 확인 모음」의 열린 행을 여기에 요약한다.

## 규칙 — 규칙이 곧 스펙이다

`.claude/rules/` 의 문서는 참고 자료가 아니라 준수 대상이다. **작업을 시작하기 전에 그 작업의 규칙을 먼저 읽는다.**

| 등급 | 파일 | 로딩 |
| --- | --- | --- |
| 상시 | `code-principles.md` · `security.md` · `testing.md` · `conventions.md` · `git-workflow.md` | 늘 |
| 필요할 때(확장자 없음) | 아래 표 | 직접 읽는다 |
| 프로젝트가 더하는 것 | 스택을 고른 뒤 생기는 규칙(프레임워크 관례 · 인터페이스 규약 · 스키마 · 배포) | `paths:` 머리말을 단 `.md` 로 더해 그 경로를 다룰 때만 싣는다 |

| 이럴 때 | 읽을 것 |
| --- | --- |
| 기획 원문에서 요구 도출 | `requirements-engineering/source-intake`(0단계) → `product-definition`(0.5단계 — 새 제품 · 소유자 기획서 · 방향을 다시 잡을 때) → `requirements-pipeline` → `feature-requirements` · `prd-guide` · `prd-template` |
| 다이어그램 · 설계 문서 | `architecture-diagram/README` → `diagram-workflow`(순서 · 파일 · ID · 검증) → 종류별 문서 · `component-package-mapping` |
| 여러 항목 요청 · 서브에이전트 · 동시 세션 · 새 교훈 | `workflow` |
| 결정 번호 · 위임받은 선택 · 결정 뒤집기 | `decisions` |
| 제품 동작 정하기(식별자 · 삭제 · 이력 · 범위 · 유료 API · 권한) | `product-judgement` |
| 개발 문서 문체 | `writing-style` |

## 아키텍처를 좌우하는 제약

- **역할 경계**(`code-principles.md` §1): 요구 · 아키텍처 문서와 승인된 스펙은 사람의 것이다. 에이전트는 초안을 쓰고 「승인 대기」로 표시한다. 다른 구조가 필요하거나 코드와 스펙이 모순되면 **보고한다** — 승인 문서를 고치거나 계층 · 컴포넌트 이름을 발명하지 않는다. 스택 선택과 품질 트레이드오프도 사람이 정한다.
- **12-Factor 는 첫 커밋부터**: 설정은 환경변수로만, 프로세스는 무상태, 로그는 표준 출력, 재시도가 있는 흐름은 멱등이고 중복 전송 때 동작을 설계에 적는다.
- **민감 데이터**(시크릿 · 개인정보 · 인증정보 · 결제정보)는 코드 · 로그 · 오류 · 시험 픽스처에 두지 않는다. 필드 목록은 프로젝트 NFR 한 곳에 정한다(`security.md` §4).
- **근거 없는 것은 만들지 않는다**: 요구는 위 계층의 ID 를, 다이어그램 요소는 FR · NFR 을, 코드는 스펙을 근거로 가진다. 근거가 없으면 만들지 않고 질문(`Q-NNN`)으로 남긴다.

## 예시 값

화면 · 문서 · 시험의 예시는 가짜만 쓴다: 회사 「예시회사」 · 사람 「홍길동」 · 전화 「010-1234-5678」 · 이메일 `user@example.com` · 도메인 `example.com`. 사람 · 고객 · 회사에 묶인 실제 값(번호 · 이름 · 금액)은 쓰지 않는다. 공공 참조 값(행정구역 · 역 · 공공 데이터)은 출처 · 기준일과 함께 실제 값을 쓴다(`conventions.md` §4).

## 작업 노하우 요약

1. 위임받은 선택은 권장안을 골라 D 번호로 남기고 계속한다. 파괴적이거나 밖으로 나가는 행동만 명시 승인을 받는다.
2. 문서가 입력이다. 대화에만 있는 결정은 다음 세션 · 서브에이전트에게 없는 것이다 — 문서로 옮긴다.
3. 건수 · 집합 · 링크는 손으로 세지 않는다. 검사 스크립트가 세고, 문서에는 「통과」만 적는다.
4. 기존 화면 · 데이터 · 문서 번호는 그대로 둔다. 지운 것은 결번으로 남기고 번호를 다시 쓰지 않는다.
5. 저장 계층은 실제 저장소로 시험하고, 실패 케이스부터 쓰고, 기준선 시험 수 아래로 내려가지 않는다.
6. 식별자는 합치지 않는다. 참조 데이터는 지운 행을 남기고 같은 값으로 다시 만들면 되살린다. 개인정보는 지우거나 익명화하고 되살리지 않는다.
7. 외부 서비스는 포트 뒤에 두고, 키가 없으면 꺼진 채 「연결 전」을 보인다.
8. 서브에이전트 effort 는 작업 종류로 고르고(탐색 · 시험 low, 구현 medium~high, 리뷰 · 설계 high), 동시 세션은 번호를 먼저 잡는다.
9. 정확해야 하는 긴 출력은 파일로 써서 읽는다. 셸 출력은 줄이 빠질 수 있다.

## Git

- 커밋은 `<type>(<scope>): <한글 subject>`(feat · fix · docs · style · refactor · perf · test · chore · ci). 시험은 구현과 같은 커밋에 넣는다.
- 모드 A: main 직접 push · force push 금지, 브랜치 + PR. 모드 B: 커밋 · 브랜치 전환은 요청받을 때만, push · `gh` 는 쓰지 않는다(기본 `permissions.deny` 가 막는다 — 모드 A 는 `Bash(git push*)` · `Bash(gh *)` 두 줄을 지운다).
- 하네스 파일(`CLAUDE.md` · `.claude/**`)은 소유자가 지시한 작업에서만 고친다.

## 알려진 틈

- `permissions.deny` 는 명령 글자를 맞춰 본다. 별칭 · 변수 · 옵션 순서를 바꾼 같은 명령은 막지 못한다. 훅이 없는 규칙은 리뷰로 지킨다 — 「훅이 막았다」고 말하지 않는다.
- 이 템플릿이 고친 `.specify/templates/*` 는 `.specify/integrations/speckit.manifest.json` 의 해시와 다르다. Spec Kit 을 올리면 덮어쓸 수 있으니 올린 뒤 diff 를 본다.
- `scripts/check-*.sh` 는 정해진 표기만 읽는다(각 스크립트 머리 주석). 판단이 필요한 대응은 사람이 본다.
- 코드가 없는 동안 `security.md` 의 강제 수단은 deny 와 리뷰뿐이다. 시험으로 올린 규칙만 「시험」으로 고쳐 적는다.
