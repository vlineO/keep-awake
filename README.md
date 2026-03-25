# KeepAwake 🖱️⌨️

Windows PC 잠금 방지 스크립트 — 회사 보안 정책으로 인한 화면보호 자동잠금을 우회합니다.

마우스 미세 이동(1px 이동 후 복귀) + 키보드 입력(ScrollLock 토글)을 주기적으로 수행하여 PC가 유휴 상태로 인식되지 않도록 합니다.

## 🚀 Quick Start

### BAT 버전 (추천 — 더블클릭으로 실행)

1. `KeepAwake.bat` 다운로드
2. **더블클릭** — 끝!

### PowerShell 버전

```powershell
# 최초 1회: 실행 정책 허용
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# 실행
.\KeepAwake.ps1
```

## ⚙️ 설정

두 버전 모두 스크립트 상단에서 실행 간격을 변경할 수 있습니다.

| 파일 | 변수 | 기본값 |
|------|------|--------|
| `KeepAwake.bat` | `set INTERVAL=240` | 240초 (4분) |
| `KeepAwake.ps1` | `$IntervalSeconds = 240` | 240초 (4분) |

> 💡 10분 잠금 정책 기준, 4분 간격이면 충분합니다.

## 🛠️ 동작 원리

| 방식 | 설명 |
|------|------|
| 마우스 미세 이동 | `mouse_event` Win32 API — 1px 이동 후 즉시 복귀 (눈에 보이지 않음) |
| ScrollLock 토글 | 눌렀다 떼기 — 작업에 전혀 영향 없음 |

## 📋 요구 사항

- Windows 10 / 11
- BAT 버전: 추가 설정 없음
- PS1 버전: PowerShell 실행 정책 허용 필요

## 🛑 중지 방법

- **BAT**: 창 닫기 또는 `Ctrl+C`
- **PowerShell**: `Ctrl+C`

## ⚠️ 참고

이 스크립트는 개인 생산성 도구입니다. 회사 보안 정책을 확인한 후 사용하세요.

## License

MIT
