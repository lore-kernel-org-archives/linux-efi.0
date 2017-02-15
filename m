From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark images
Date: Wed, 15 Feb 2017 19:14:38 +0100
Message-ID: <cover.1487182480.git.jan.kiszka@siemens.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-efi@vger.kernel.org

See patch 2 for the background.

Series has been tested on the Galileo Gen2, to exclude regressions, with
a firmware.cap without security header and the SIMATIC IOT2040 which
requires the header because of its mandatory secure boot.

Jan

Jan Kiszka (2):
  efi/capsule: Prepare for loading images with security header
  efi/capsule: Add support for Quark security header

 drivers/firmware/efi/capsule-loader.c | 73 ++++++++++++++++++++++++++++++-----
 drivers/firmware/efi/capsule.c        | 19 +++++++--
 include/linux/efi.h                   |  2 +-
 3 files changed, 79 insertions(+), 15 deletions(-)

-- 
2.1.4
