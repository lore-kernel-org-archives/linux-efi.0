From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Mon, 9 Mar 2015 21:00:35 +0100
Message-ID: <20150309200035.GK12732@pd.tnic>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
 <20150309124935.GA12732@pd.tnic>
 <CAE9FiQWc+mnepaqr8RvRXkyhyaOY_C=KvE_A0Ojf_jda3KmFBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQWc+mnepaqr8RvRXkyhyaOY_C=KvE_A0Ojf_jda3KmFBA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 09, 2015 at 12:35:25PM -0700, Yinghai Lu wrote:
> Can you put back:
> "
> So need to make sure [z_extra_offset, init_size) will fit ZO, that means
> init_size need to be adjusted according to ZO size.
> That make init_size is always >= run_size.

Why?

We don't adjust init_size. We assign INIT_SIZE to it. Or do you want to
say that we indirectly adjust init_size through INIT_SIZE?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
