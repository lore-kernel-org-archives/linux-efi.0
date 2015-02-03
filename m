From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Avoid triple faults during EFI mixed mode calls
Date: Tue, 3 Feb 2015 20:08:29 +0100
Message-ID: <20150203190829.GA18734@pd.tnic>
References: <1422375124-21265-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422375124-21265-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 27, 2015 at 04:12:04PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Andy pointed out that if an NMI or MCE is received while we're in the
> middle of an EFI mixed mode call a triple fault will occur. This can
> happen, for example, when issuing an EFI mixed mode call while running
> perf.
> 
> The reason for the triple fault is that we execute the mixed mode call
> in 32-bit mode with paging disabled but with 64-bit kernel IDT handlers
> installed throughout the call.
> 
> At Andy's suggestion, stop playing the games we currently do at runtime,
> such as disabling paging and installing a 32-bit GDT for __KERNEL_CS. We
> can simply switch to the __KERNEL32_CS descriptor before invoking
> firmware services, and run in compatibility mode. This way, if an
> NMI/MCE does occur the kernel IDT handler will execute correctly, since
> it'll jump to __KERNEL_CS automatically.
> 
> However, this change is only possible post-ExitBootServices(). Before
> then the firmware "owns" the machine and expects for its 32-bit IDT
> handlers to be left intact to service interrupts, etc.
> 
> So, we now need to distinguish between early boot and runtime
> invocations of EFI services. During early boot, we need to restore the
> GDT that the firmware expects to be present. We can only jump to the
> __KERNEL32_CS code segment for mixed mode calls after ExitBootServices()
> has been invoked.
> 
> A liberal sprinkling of comments in the thunking code should make the
> differences in early and late environments more apparent.
> 
> Reported-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Boots fine on my Dell box.

Tested-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
