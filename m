From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [efi:next 25/27] drivers/firmware/efi/test/efi_test.c:269:8-15:
 WARNING opportunity for memdup_user
Date: Tue, 6 Sep 2016 02:18:43 +0800
Message-ID: <201609060241.wcHLKv2z%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
head:   daed0a8a36e7e0bc8eb76a53a4edce02d245cac1
commit: f8c1a021147e8d3a6ca5c3d86de44956a6b03168 [25/27] efi: Add efi_test driver for exporting UEFI runtime service interfaces


coccinelle warnings: (new ones prefixed by >>)

>> drivers/firmware/efi/test/efi_test.c:269:8-15: WARNING opportunity for memdup_user

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
