From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 0/2] efi/fdt: get_fdt cleanups
Date: Mon, 29 Oct 2018 10:15:40 +0000
Message-ID: <1540808142-33208-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, joe@perches.com, Julien Thierry <julien.thierry@arm.com>
List-Id: linux-efi@vger.kernel.org

Hi,

Here are just some minor cleanups of get_fdt function.

Changes since v1:
- Add a set of brace for the for loop
- Reorganize code as suggested by Joe

[1] https://lkml.org/lkml/2018/10/1/465

Thanks,

Julien

-->

Julien Thierry (2):
  efi/fdt: Indentation fix
  efi/fdt: Simplify get_fdt flow

 drivers/firmware/efi/libstub/fdt.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--
1.9.1
