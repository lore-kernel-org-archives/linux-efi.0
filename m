From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: rename the efivars module
Date: Thu, 21 Feb 2013 14:25:42 +0000
Message-ID: <1361456742.2842.21.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1361149277-1026-1-git-send-email-teg@jklm.no>
	 <1361149277-1026-2-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361149277-1026-2-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-02-18 at 02:01 +0100, Tom Gundersen wrote:
> As part of the splitting up of efivars this got renamed to 'sysfs', rename it
> back to 'efivars' for backwards compatibility.
> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig   |   2 +
>  drivers/firmware/efi/Makefile  |   2 +-
>  drivers/firmware/efi/efivars.c | 555 +++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/sysfs.c   | 555 -----------------------------------------
>  4 files changed, 558 insertions(+), 556 deletions(-)
>  create mode 100644 drivers/firmware/efi/efivars.c
>  delete mode 100644 drivers/firmware/efi/sysfs.c

Good point!

In order to avoid introducing a bisection problem we're probably going
to have to do the sysfs and efivars split together, so that we don't end
up with two files called efivars.c.

I'll rejiggle the patches to avoid this problem, thanks.
