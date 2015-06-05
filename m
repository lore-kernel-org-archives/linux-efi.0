From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] efi: Work around ia64 build problem with ESRT driver.
Date: Fri, 5 Jun 2015 17:14:22 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32A8DBEA@ORSMSX114.amr.corp.intel.com>
References: <5571B70B.90108@roeck-us.net>
 <1433523746-21734-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433523746-21734-1-git-send-email-pjones@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>, Guenter Roeck <linux@roeck-us.net>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

-obj-$(CONFIG_EFI)			+= efi.o esrt.o vars.o reboot.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
+ifeq ($(CONFIG_IA64),)
+obj-$(CONFIG_EFI)			+= esrt.o
+endif
 
I doubt that ia64 systems are going to start implementing ERST - so it's fine with me
to drop it from the build.

Guenter's suggestion of a new CONFIG_EFI_ESRT looks a bit prettier that that
    ifeq ($(CONFIG_IA64),)

but either way:

Acked-by: Tony Luck <tony.luck@intel.com>
