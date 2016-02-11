From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 1/3] efi: use a file local lock for efivars
Date: Thu, 11 Feb 2016 13:14:22 +0000
Message-ID: <20160211131422.GB4134@codeblueprint.co.uk>
References: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-2-git-send-email-sylvain.chouleur@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452702762-27216-2-git-send-email-sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Jan, at 05:32:40PM, Sylvain Chouleur wrote:
> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch remove the efivars lock to use a single lock for the whole
> vars.c file.  The goal of this lock is to protect concurrent calls to
> efi variable services, registering and unregistering.  This allows to
> register new efivars operations without having in-progress call.
> 
> Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 85 +++++++++++++++++++++++++--------------------
>  include/linux/efi.h         |  6 ----
>  2 files changed, 48 insertions(+), 43 deletions(-)

Sorry for the delay in reviewing this. I wasn't on Cc so I only found
it when searching through the linux-efi archive.

This change looks fine to me and a nice clean up. Ard any comments?
