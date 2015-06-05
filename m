From: Guenter Roeck <linux@roeck-us.net>
Subject: Build error in -next due to 'efi: Add esrt support'
Date: Fri, 05 Jun 2015 07:49:47 -0700
Message-ID: <5571B70B.90108@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Building ia64:defconfig ... failed
--------------
Error log:

drivers/firmware/efi/esrt.c:28:31: fatal error: asm/early_ioremap.h: No such file or directory

Guenter
