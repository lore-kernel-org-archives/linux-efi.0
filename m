From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/5] efi: make our variable validation list include the
 guid (v3)
Date: Thu, 4 Feb 2016 22:54:31 +0000
Message-ID: <20160204225431.GH2586@codeblueprint.co.uk>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
 <1454600074-14854-5-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454600074-14854-5-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 04 Feb, at 10:34:33AM, Peter Jones wrote:
> v2 correctly checks the guid for validation *as well as* attribute
> whitelisting.
> v3 moves the sorting of variable_validate here and adds a comment about
> it.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/efivars.c |  5 ++--
>  drivers/firmware/efi/vars.c    | 52 +++++++++++++++++++++++++++---------------
>  include/linux/efi.h            |  3 ++-
>  3 files changed, 38 insertions(+), 22 deletions(-)

I've expanded on the commit message ever so slightly so that a casual
observer can figure out why this change was made.

Something like this?

---

  efi: Make our variable validation list include the guid
  
  This list of variables is defined to be part of the global namespace
  in the UEFI spec, so this just further ensures we're validating the
  variables we think we are.
  
  Including the guid for entries will become more important in future
  patches when we decide whether or not to allow deletion of variables
  based on presence in this list.
