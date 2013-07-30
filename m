From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] urgent fix
Date: Tue, 30 Jul 2013 20:52:12 +0200
Message-ID: <20130730185212.GA21687@gmail.com>
References: <20130729080836.GD2515@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130729080836.GD2515@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:
> 
>   Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to df981edcb9bce00b9c5e4f3cc33f3f98bc9a2394:
> 
>   x86, efi: correct call to free_pages (2013-07-26 15:22:32 +0100)
> 
> ----------------------------------------------------------------
>  * The size of memory that gets freed by free_pages() needs to be
>    specified in pages, not bytes - Roy Franz.
> 
> ----------------------------------------------------------------
> Roy Franz (1):
>       x86, efi: correct call to free_pages
> 
>  arch/x86/boot/compressed/eboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pulled into tip:x86/urgent, thanks Matt!

	Ingo
