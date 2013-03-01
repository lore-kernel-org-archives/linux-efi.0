From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5] efi: split efisubsystem from efivars
Date: Fri, 01 Mar 2013 19:59:49 +0000
Message-ID: <1362167989.2842.449.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1361904220-1248-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361904220-1248-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tobias Powalowski <tpowa-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-02-26 at 19:43 +0100, Tom Gundersen wrote:
> This registers /sys/firmware/efi/{,systab,efivars/} whenever EFI is enabled
> and the system is booted with EFI.
> 
> This allows
>  *) userspace to check for the existence of /sys/firmware/efi as a way
>     to determine whether or it is running on an EFI system.
>  *) 'mount -t efivarfs none /sys/firmware/efi/efivars' without manually
>     loading any modules.
> 
> v5: remove unnecessary #ifdef's
> v4: rebase on top of the chainsaw branch:
>     - split into efi.c and vars.c
>     - move systab from vars.c to efi.c
>     - address checkpatch warnings
> v3: rebase on top of new efi_enabled()
> v2: only create /sys/firmware/efi/efivars if the module is being compiled,
>     and move extern's to efi.h
> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
> Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>
> Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Tobias Powalowski <tpowa-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> ---
>  drivers/firmware/Makefile     |   1 -
>  drivers/firmware/efi/Makefile |   2 +
>  drivers/firmware/efi/efi.c    | 105 +++++
>  drivers/firmware/efi/vars.c   | 858 +++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efivars.c    | 955 ------------------------------------------
>  include/linux/efi.h           |   2 +
>  6 files changed, 967 insertions(+), 956 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi.c
>  create mode 100644 drivers/firmware/efi/vars.c
>  delete mode 100644 drivers/firmware/efivars.c

Thanks Tom, I've picked this up. I need to respin this branch against
Linus' because there were some efivars change this merge window.
