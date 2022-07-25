import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:win32/win32.dart';

List<String> _winTitleList = [];

// Callback for each window found
int enumWindowsProc(int hWnd, int lParam) {
  // Don't enumerate windows unless they are marked as WS_VISIBLE
  if (IsWindowVisible(hWnd) == FALSE) return TRUE;

  final length = GetWindowTextLength(hWnd);
  if (length == 0) {
    return TRUE;
  }

  final buffer = wsalloc(length + 1);
  GetWindowText(hWnd, buffer, length + 1);
  // print('hWnd $hWnd: ${buffer.toDartString()}');
  _winTitleList.add(buffer.toDartString());
  free(buffer);
  return TRUE;
}

List<String> getWindowTitleList() {
  _winTitleList = [];

  final wndProc = Pointer.fromFunction<EnumWindowsProc>(enumWindowsProc, 0);
  EnumWindows(wndProc, 0);

  return _winTitleList;
}

int findWindowByTitle(String title) {
  final winTitleList = getWindowTitleList();
  int hwnd = 0;
  for (final t in winTitleList) {
    if (t.contains(title)) {
      hwnd = FindWindow(nullptr, TEXT(t));
      break;
    }
  }
  return hwnd;
}

void hideWindow(int hwnd) {
  ShowWindow(hwnd, SW_HIDE);
}
