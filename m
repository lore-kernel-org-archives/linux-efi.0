From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 08/44] kernel: Move pm_power_off to common code
Date: Fri, 10 Oct 2014 09:53:52 -0700
Message-ID: <54380F20.3060800@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-9-git-send-email-linux@roeck-us.net> <20141009103847.GC6787@amd> <54368A30.9070101@roeck-us.net> <20141009202419.GA16885@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20141009202419.GA16885@amd>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Pavel Machek <pavel@denx.de>
Cc: linux-kernel@vger.kernel.org, adi-buildroot-devel@lists.sourceforge.net, devel@driverdev.osuosl.org, devicetree@vger.kernel.org, lguest@lists.ozlabs.org, linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org, linux-am33-list@redhat.com, linux-cris-kernel@axis.com, linux-efi@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org, linux-xtensa@linux-xtensa.org, openipmi-developer@lists.sourceforge.net, user-mode-linux-devel@lists.sourceforge.net, linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-metag@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.orglinux-
List-Id: linux-efi@vger.kernel.org

On 10/09/2014 01:24 PM, Pavel Machek wrote:
> Hi!
>
>>>> @@ -184,6 +179,8 @@ machine_halt(void)
>>>>   void
>>>>   machine_power_off(void)
>>>>   {
>>>> +	do_kernel_poweroff();
>>>> +
>>>
>>> poweroff -> power_off for consistency.
>>>
>> Dunno; matter of personal preference. I started with that, but ultimately went
>> with poweroff to distinguish poweroff handler functions from existing code,
>> specifically kernel_power_off().
>
> That works for you, but once it is merged, it is ugly/confusing typo.
> 									Pavel
>

Ok, no problem, I'll change it.

Guenter
