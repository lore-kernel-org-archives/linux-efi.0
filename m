From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 03/17] Add system pointer argument to shared EFI stub
 related functions so they no longer use global system table pointer as they
 did when part of eboot.c.
Date: Wed, 7 Aug 2013 22:55:54 +0100
Message-ID: <20130807215554.GI2515@console-pimps.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
 <1375847113-24884-4-git-send-email-roy.franz@linaro.org>
 <20130807130851.GC2515@console-pimps.org>
 <CAFECyb8NbZ=hrAGyoV-UPUhh-Jst6ZVRk9RUQj_Kb1qq_xuUAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb8NbZ=hrAGyoV-UPUhh-Jst6ZVRk9RUQj_Kb1qq_xuUAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, Russell King - ARM Linux <linux@arm.linux.org.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Dave Martin <dave.martin@arm.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Aug, at 10:10:54AM, Roy Franz wrote:
> I went this way since the shared code is in a separate file - I really
> didn't like using a global variable as part of the interface to
> the shared code.  This has the nice side benefit of allowing the ARM
> stub to not use any global variables, so we don't have to do
> any GOT fixups to relocate the code - it is position independent if we
> don't use global variables.

OK, that would be a win. Please include this rationale in the patch.

-- 
Matt Fleming, Intel Open Source Technology Center
