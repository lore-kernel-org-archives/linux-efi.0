From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [BUG]: DELL XPS 8500 become a brick after fill too many entries to nvram.
Date: Mon, 11 Nov 2013 14:15:22 +0800
Message-ID: <87fvr3h3b9.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Howdy all,
  For now we ensure at least ~5kb free space. But my dell xps still
  become a brick after I add too many entries to my nvram. So maybe 5kb
  is not safe enough. and 5kb is just aginst Samsung's laptop.
  So should we enlarge EFI_MIN_RESERVE?
-- 
Best,
Madper Xie.
