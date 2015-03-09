From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Mon, 9 Mar 2015 16:58:13 +0100
Message-ID: <20150309155813.GA21755@gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
 <20150309124935.GA12732@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150309124935.GA12732@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Borislav Petkov <bp@suse.de> wrote:

> On Sat, Mar 07, 2015 at 02:07:15PM -0800, Yinghai Lu wrote:
> 
> ...
> 
> I ended up committing this. Anything I've missed?

So this would be fine as-is for v4.1, but I think we want to attempt 
to fix this in x86/urgent so that we don't have to revert the kaslr 
changes in v4.0, so it would be awesome if you could split it into two 
parts: the fix, plus the orphaned run_size removal?

That would make it easier to bisect to, should anything break ...

Thanks,

	Ingo
