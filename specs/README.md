# specs — 스펙 폴더 쓰는 법

이 폴더는 기능마다 「무엇을 왜 만드는가(spec) → 어떻게 만드는가(plan) → 어떤 순서로(tasks)」를 남기는 곳이다.
스펙킷 스킬(`speckit-specify` → `speckit-clarify` → `speckit-plan` → `speckit-tasks` → `speckit-analyze` → `speckit-implement`)이 이 폴더에 쓴다.
작업 단계 · 게이트 · 역할은 `.claude/rules/workflow`, 결정 번호 규칙은 `.claude/rules/decisions`, 번호 예약은 `DECISIONS.md` 가 정본이다.

## 1. 폴더 구조

```
specs/
├─ README.md            이 문서
├─ DECISIONS.md         결정 · 미결 · 스펙 번호 레지스트리
├─ _templates/          경량 형식 · 백로그 · 감사 · 계약 양식(아래 §4)
└─ NNN-<짧은-이름>/      스펙 하나 = 디렉터리 하나
   ├─ spec.md           필수
   ├─ plan.md · research.md · data-model.md · quickstart.md · tasks.md   형식에 따라
   ├─ contracts/        정식 형식의 인터페이스 계약
   └─ checklists/       요구 품질 점검(requirements.md) · 화면 글 점검 등
```

## 2. 형식 고르기

| 형식 | 언제 | 산출물 | 양식 |
| --- | --- | --- | --- |
| **정식** | 제품 첫 구현이거나, 상위 요구 문서(SRS · C4)에서 새 FR 이 내려오거나 기존 FR 을 개정할 때. 전건 추적이 필요할 때 | spec · plan · research · data-model · contracts · quickstart · tasks · checklists | `.specify/templates/*` · `_templates/{research,data-model,quickstart,contracts}.md` |
| **델타** | 정식 스펙이 이미 있는 코드 위에 큰 변경 · 결함 일괄 수정 · 여러 에이전트 병렬 작업 | 정식과 같다. 베이스라인 스펙은 다시 쓰지 않는다. spec 에 「상위 스펙 보완 · 충돌 기록」, plan 에 작업 흐름 · 파일 소유 | 정식 양식의 델타 절 |
| **경량** | 소유자의 지시 · 피드백으로 기존 FR 안에서 동작을 바꿀 때. 화면 수정 · 1~2일 작업 | `spec.md` 하나(요구 · 범위 밖 · 결정 · 확인 필요 · 검증 기록). 조사가 결정을 좌우하면 `research.md`, 데이터 · API 가 여럿이면 `plan.md` 를 더한다 | `_templates/spec-light.md` · `plan-light.md` · `research.md` |
| **문서 단위** | 결정만 하면 되는 설계 · 계획 · 비교(코드 없음) | 경량과 같고 머리 표에 「성격: 문서 단위다. 코드 · 설정을 바꾸지 않는다」 | `_templates/spec-light.md` |
| **보류** | 일정이 미뤄진 기능 | 문서는 지우지 않고 맨 위에 보류 배너: `> **보류 — 범위 밖 (YYYY-MM-DD 결정 D-nnn)** — 다시 열 조건: …` | — |
| **백로그** | 한 번에 요청이 여럿 올 때 | `specs/backlog-YYYY-MM-DD.md` 한 장으로 작업 단위를 나누고, 단위마다 위 형식 중 하나 | `_templates/backlog.md` |

한 줄 기준: **새 FR 이 생기면 정식, 기존 FR 안의 동작 변경이면 경량, 조사가 결정을 좌우하면 research 를 더하고, 코드가 없으면 문서 단위.**

## 3. 번호 · 브랜치

1. **스펙 번호**는 세 자리 순번(`001`, `002` …). `mkdir` 직전에 `ls specs/` 와 `DECISIONS.md` 「스펙 번호」 표를 보고, 표에 먼저 행을 넣어 잡는다.
2. **데이터 이행이 생기면 그 이유를 적은 스펙 디렉터리**(최소 `spec.md`)를 반드시 만든다 — 스펙 없이 이행 파일만 있으면 나중에 아무도 이유를 찾지 못한다.
3. **브랜치 이름 = 스펙 디렉터리 이름**(`NNN-<짧은-이름>`, 브랜치를 만드는 모드 A). 활성 스펙은 `.specify/scripts/bash/common.sh` 가 이 순서로 정한다: ① 환경변수 `SPECIFY_FEATURE_DIRECTORY` ② `.specify/feature.json` 의 `feature_directory`(`speckit-specify` 가 쓴다) ③ 브랜치 이름의 번호 접두. `feature.json` 이 있으면 브랜치를 바꿔도 활성 스펙이 바뀌지 않으므로, 모드 A 는 브랜치를 바꾼 뒤 `feature.json` 을 고치거나 `SPECIFY_FEATURE_DIRECTORY=specs/NNN-<이름>` 을 준다(`SPECIFY_FEATURE` 는 ③의 브랜치 이름만 바꾼다). 브랜치를 만들지 않는 모드 B 는 `feature.json` 으로 고른다 — 공유 작업 트리에서 `feature.json` 은 다른 세션도 보는 포인터라 바꾸면 보고한다. 운영 모드는 `.claude/rules/git-workflow.md`.
4. **커밋은 모드대로 한다.** 모드 A 는 스펙마다 작업 트리를 나누고 결정 단위로 커밋한다 — 여러 스펙 작업이 한 작업 트리를 공유하면 기능별 커밋이 불가능해지고 스펙 ↔ 커밋 대응이 사라진다. 모드 B 는 한 작업 트리를 같이 쓰고 소유자가 작업을 묶어 커밋한다. 여러 스펙의 중간 상태가 섞이면 커밋 본문에 그 사실을 적는다. 어느 모드든 커밋 subject 끝에 결정 번호 괄호 `(D-012 · D-013)`.
5. **결정 번호는 저장소 전역**이다. 스펙 머리 표에 예약 범위를 적고, 그 범위 안에서만 쓴다(`DECISIONS.md`).

## 4. 양식 목록 (`_templates/`)

| 파일 | 쓰는 곳 |
| --- | --- |
| `spec-light.md` · `plan-light.md` | 경량 · 문서 단위 스펙 |
| `research.md` | 정식 · 경량 공통 조사 기록(결정 근거 · 버린 대안 · 출처 접속일) |
| `data-model.md` | 정식 · 델타의 데이터 모델 |
| `quickstart.md` | 정식 · 델타의 검증 시나리오 |
| `contracts.md` | `contracts/` 아래로 복사해 쓰는 인터페이스 계약(API · 명령 · 이벤트 · 정기 작업). 전송 방식의 공통 규약은 스택을 고른 뒤 프로젝트 규칙 한 곳에 두고 링크한다 |
| `backlog.md` | 여러 요청을 작업 단위로 나누는 오케스트레이션 문서 |
| `audit-map.md` · `audit-issues.md` | 첫 구현 뒤 영역별 감사 — 구현 지도 → 결함 목록(`.claude/rules/workflow` §8) |
| `subagent-brief.md` | 서브에이전트에게 단위 작업을 맡기는 지시문 |

정식 형식의 spec · plan · tasks · checklist 양식은 `.specify/templates/` 에 있다(스킬이 직접 읽는다).

## 5. 모든 스펙에 공통인 관례

- **원문은 「」로 그대로 인용**하고, 요구로 다시 쓸 때 번호를 붙인다(원문 번호 ①② 유지).
- **「이 문서의 위치」**: 무엇이 정본이고 어긋나면 누가 이기는지 첫머리에 적는다.
- **상위 문서와 어긋나면 고치지 않고 보고만** 한다. 처리 값은 `D-nnn` / 「이 문서 결정」 / 「보고만」 셋.
- **결정에는 버린 대안과 되돌리는 비용**을 적는다. 수치는 「잠정」, 모르는 도구는 「미정」 + 선정 기준.
- **실패 시나리오가 먼저** — spec 시나리오 순서 · tasks 「실패 먼저: / 성공:」 · quickstart 표.
- **조용한 성공 금지** — 제공하지 않는 기능 · 키가 없는 기능 · 실패한 정기 작업이 성공처럼 보이지 않는다.
- **결번은 지우지 않는다** — FR · 결정 폐지 모두 취소선 + 사유.
- **개정은 배너로** — 승인 뒤 바뀌면 본문을 다시 쓰지 않고 맨 위에 `> **개정 YYYY-MM-DD** — … 본문의 해당 문장은 이 표가 이긴다. 영향 받는 본문: §…` 를 붙인다. 영향 줄 목록을 남겨 본문과 배너가 어긋난 채 잊히지 않게 한다.
- **하네스 문서(CLAUDE.md · `.claude/**`)는 스펙 작업이 고치지 않는다** — plan 「문서 갱신 제안」 절로 넘긴다. 예외는 `speckit-plan` 이 바꾸는 `CLAUDE.md` 의 `SPECKIT START/END` 블록과, 결정 행을 쓴 작업이 더하는 결정 색인 새 행이다(`.claude/rules/decisions` §7).
- **커버리지는 명령으로** — `scripts/check-spec-coverage.sh` 결과를 checklist 의 Coverage 절에 적는다.
