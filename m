From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 0/3] arm64: EFI stub isolation
Date: Sat, 10 Oct 2015 23:40:51 +0100
Message-ID: <20151010224051.GK2723@codeblueprint.co.uk>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444330924-17830-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Oct, at 08:02:01PM, Ard Biesheuvel wrote:
> We need to ensure that the EFI stub only uses parts of the kernel proper
> that are safe to use when the kernel virtual mapping is not active yet.
> 
> So move all C code dependencies to the libstub, which is built with all
> instrumentation (gcov, kasan) disabled, and do a verification pass to
> ensure that no absolute relocations are used.
> 
> On the arm64 side, annotate all the stub's dependencies as safe for PI
> (position independent
> 
> @Matt: if you are OK with these, may we please have your ack on patches #1 and
> #2 so that Catalin can pick up the series? Thanks.

I assumed you meant PATCH 1 and PATCH 3. If so, yeah, these look fine
to be taken through Catalin's tree.

-- 
Matt Fleming, Intel Open Source Technology Center
