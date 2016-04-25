From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] EFI urgent fix
Date: Mon, 25 Apr 2016 17:29:38 +0200
Message-ID: <20160425152938.GA12231@gmail.com>
References: <1461583602-31599-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461583602-31599-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, Jani Nikula <jani.nikula@linux.intel.com>, Jason Andryuk <jandryuk@gmail.com>, Laszlo Ersek <lersek@redhat.com>, Matthew Garrett <mjg59@coreos.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Folks, please pull the following fix from Laszlo that ensures we don't
> perform an out-of-bounds access when matching EFI variable names
> against the variable protection whitelist.
> 
> The following changes since commit c3b46c73264b03000d1e18b22f5caf63332547c9:
> 
>   Linux 4.6-rc4 (2016-04-17 19:13:32 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> 
> for you to fetch changes up to 630ba0cc7a6dbafbdee43795617c872b35cde1b4:
> 
>   efi: Fix out-of-bounds read in variable_matches() (2016-04-22 19:41:41 +0100)
> 
> ----------------------------------------------------------------
>  * Avoid out-of-bounds access in the efivars code when performing
>    string matching on converted EFI variable names - Laszlo Ersek
> 
> ----------------------------------------------------------------
> Laszlo Ersek (1):
>       efi: Fix out-of-bounds read in variable_matches()
> 
>  drivers/firmware/efi/vars.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)

Pulled into tip:efi/urgent, thanks Matt!

	Ingo
