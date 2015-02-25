From: Borislav Petkov <bp@alien8.de>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Wed, 25 Feb 2015 12:47:47 +0100
Message-ID: <20150225114747.GC3226@pd.tnic>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Sam Protsenko <semen.protsenko@linaro.org>, Matt Fleming <matt@console-pimps.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 24, 2015 at 12:49:09PM +0000, Kweh, Hock Leong wrote:
> So the process steps basically look like this:
> 1.) cat capsule_ticket    =======> acquire a number and lock mutex then
>                                                                      expose firmware_class user helper
>                                                                      interface as well as start timer for timeout
>                                                                      counting
> 2.) repeat step 1 if obtained a "0" number
> 3.) echo 1 > loading
> 4.) cat bin > data
> 5.) echo 0 > loading        =======> stop the timeout counting  then unlock
>                                                                       mutex at the end of callback routine 
> 6.) cat capsule_report   =======> grep the number acquired from beginning
>                                                                       for checking succeeded/failed

So this sounds pretty overengineered for no reason, or maybe I'm missing
the reason.

If I had to give an example from the microcode loader, what we do there
is put the microcode in /lib/firmware/... and do

echo 1 > /sys/devices/system/cpu/microcode/reload

which goes and calls reload_store() in
arch/x86/kernel/cpu/microcode/core.c which grabs a mutex, disables CPU
hotplug, etc, etc...

And this mechanism is as simple as it can get. Maybe capsules can be
loaded like that too?

Error code can be propagated too, if needed, of course.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
