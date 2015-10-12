From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 0/3] arm64: EFI stub isolation
Date: Mon, 12 Oct 2015 16:30:02 +0100
Message-ID: <20151012153002.GC6320@e104818-lin.cambridge.arm.com>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
 <20151010224051.GK2723@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151010224051.GK2723-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 10, 2015 at 11:40:51PM +0100, Matt Fleming wrote:
> On Thu, 08 Oct, at 08:02:01PM, Ard Biesheuvel wrote:
> > We need to ensure that the EFI stub only uses parts of the kernel proper
> > that are safe to use when the kernel virtual mapping is not active yet.
> > 
> > So move all C code dependencies to the libstub, which is built with all
> > instrumentation (gcov, kasan) disabled, and do a verification pass to
> > ensure that no absolute relocations are used.
> > 
> > On the arm64 side, annotate all the stub's dependencies as safe for PI
> > (position independent
> > 
> > @Matt: if you are OK with these, may we please have your ack on patches #1 and
> > #2 so that Catalin can pick up the series? Thanks.
> 
> I assumed you meant PATCH 1 and PATCH 3. If so, yeah, these look fine
> to be taken through Catalin's tree.

Thanks for the review. Patches queued for 4.4.

-- 
Catalin
