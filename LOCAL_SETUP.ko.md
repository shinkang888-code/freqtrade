# Freqtrade 로컬 실행 가이드

## 빠른 설치

```powershell
cd c:\cursor\aicryptotrader\freqtrade
.\scripts\setup-local.ps1
```

## 실행 (Dry-run, 단일 인스턴스)

```powershell
.\scripts\start-bot.ps1
```

기존 freqtrade 프로세스를 모두 종료한 뒤 **봇 1개만** 시작합니다.

- WebUI: http://127.0.0.1:8080
- 계정: `freqtrader` / `freqtrader`

## Windows 참고

- `pip install`이 멈추면 `--no-cache-dir --no-build-isolation` 옵션 사용
- async 거래소 연결 오류 시 `aiodns`, `pycares` 제거

## 배포

| 환경 | 방법 |
|------|------|
| **로컬** | `.\scripts\start-bot.ps1` (단일 인스턴스) |
| **Vercel** | 프로젝트 안내 페이지 (https://freqtrade-lac.vercel.app) |
| **Render** | `render.yaml` Blueprint로 worker 1개 배포 |

Freqtrade 봇은 상시 실행 프로세스라 Vercel Functions에는 배포할 수 없습니다.
Render worker 또는 Docker/VPS를 사용하세요.
