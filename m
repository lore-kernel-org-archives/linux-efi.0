From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/3] efi: use a file local lock for efivars
Date: Fri, 15 Jul 2016 15:04:51 +0100
Message-ID: <20160715140451.GA2406@codeblueprint.co.uk>
References: <1468249165-25523-1-git-send-email-ard.biesheuvel@linaro.org>
 <1468249165-25523-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468249165-25523-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Jul, at 04:59:23PM, Ard Biesheuvel wrote:
> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch replaces the spinlock in the efivars struct with a single lock
> for the whole vars.c file.  The goal of this lock is to protect concurrent
> calls to efi variable services, registering and unregistering. This allows
> us to register new efivars operations without having in-progress call.
> 
> Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> [ardb: rebased onto v4.7-rc3]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 83 +++++++++++---------
>  include/linux/efi.h         |  6 --
>  2 files changed, 47 insertions(+), 42 deletions(-)

Thanks Ard, applied.
