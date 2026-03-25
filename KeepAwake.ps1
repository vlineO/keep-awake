# ============================================================
# KeepAwake.ps1 - Windows PC 잠금 방지 스크립트
# ============================================================
# 사용법: PowerShell에서 실행
#   .\KeepAwake.ps1
#
# 중지: Ctrl+C
# ============================================================

# --- 설정 ---
$IntervalSeconds = 240  # 4분마다 실행 (10분 잠금 정책 대비 충분한 여유)

# --- 방법 1: SendKeys를 이용한 키 입력 시뮬레이션 ---
# ScrollLock 키를 눌렀다 떼는 방식 (화면에 영향 없음)
Add-Type -AssemblyName System.Windows.Forms

# --- 방법 2: mouse_event를 이용한 마우스 미세 이동 ---
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class MouseHelper {
    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, IntPtr dwExtraInfo);

    public const int MOUSEEVENTF_MOVE = 0x0001;

    public static void Jiggle() {
        // 마우스를 1픽셀 오른쪽으로 이동 후 다시 원위치
        mouse_event(MOUSEEVENTF_MOVE, 1, 0, 0, IntPtr.Zero);
        System.Threading.Thread.Sleep(100);
        mouse_event(MOUSEEVENTF_MOVE, -1, 0, 0, IntPtr.Zero);
    }
}
"@

# --- 메인 루프 ---
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  KeepAwake - PC 잠금 방지 스크립트 실행 중" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  간격: ${IntervalSeconds}초 ($(($IntervalSeconds / 60))분)" -ForegroundColor Yellow
Write-Host "  중지: Ctrl+C 를 누르세요" -ForegroundColor Yellow
Write-Host ""
Write-Host "-------------------------------------------"

$count = 0

try {
    while ($true) {
        $count++
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # 마우스 미세 이동 (1px 이동 후 복귀)
        [MouseHelper]::Jiggle()

        # ScrollLock 키 토글 (눌렀다 떼기 - 상태 유지)
        [System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK}")
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK}")

        Write-Host "[$timestamp] #$count - 활동 시뮬레이션 완료 (마우스 + 키보드)" -ForegroundColor Green

        # 다음 실행까지 대기
        Start-Sleep -Seconds $IntervalSeconds
    }
}
catch {
    Write-Host ""
    Write-Host "스크립트가 중지되었습니다." -ForegroundColor Red
}
finally {
    Write-Host "KeepAwake 종료." -ForegroundColor Yellow
}
