From: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH 0/3] efi_test: fix Coccinelle warning and CoverityScan issues
Date: Mon, 26 Sep 2016 11:14:48 +0800
Message-ID: <1474859691-8574-1-git-send-email-ivan.hu@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fix the memdup_user warning found by Cocinelle, and some minor uninitialized
scalar variable issues found by CoverityScan. 

Ivan Hu (3):
  efi/efi_test: use memdup_user() as a cleanup
  efi/efi_test: fix the uninitialized value datasize
  efi/efi_test: fix the uninitialized value rv

 drivers/firmware/efi/test/efi_test.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
1.9.1
