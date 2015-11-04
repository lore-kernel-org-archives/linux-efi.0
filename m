From: "Stoppa, Igor" <igor.stoppa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [x86] [EFI stub] Changing the kernel command line in the efi
 application, without recompiling the kernel.
Date: Wed, 4 Nov 2015 13:35:16 +0200
Message-ID: <CAC_FEN0qfR47ST4xewf2hc7vgH7eNm1_d-K-ZMwJWd-yNo58jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

I'm currently building a combo efi application comprised of

* uefi stub from gummiboot
* linux kernel
* kernel command line
* microcode + initramfs

using the approach from mkrescue-uefi.sh [1]

However I'd like to replace the gummiboot stub with the one coming
with the kernel, and get rid of one dependency (gummiboot).
But it seems that the command line is handled differently:

* in the gummiboot way I can change the command line without having to
recompile the kernel, because it is contained in a separate section of
the application.

* in the kernel-only way, it is contained in the field "load_options"
from efi_loaded_image_t [2]
So for what I can understand, I would have to rebuild the kernel, to
change the command line of the combo application.


Is that correct?


[1] https://github.com/haraldh/mkrescue-uefi/blob/master/mkrescue-uefi.sh
[2] http://lxr.free-electrons.com/source/include/linux/efi.h#L741

-- 
thanks, in advance, igor
