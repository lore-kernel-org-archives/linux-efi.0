From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC 2/3] firmware_class: split out transaction helpers
Date: Thu, 30 Apr 2015 15:11:20 +0200
Message-ID: <20150430131120.GB17936@kroah.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
 <1430349052.2189.41.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430349052.2189.41.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 29, 2015 at 04:10:52PM -0700, James Bottomley wrote:
> From: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
> 
> The firmware class contains code to manage an arbitrary sized buffer for
> discrete read and write operations.  We need precisely this ability to update
> firmware capsule files (and likely for other transactions as well), so split
> out the capability into a library helper
> 
> Signed-off-by: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
> ---
>  drivers/base/firmware_class.c      | 117 ++++---------------------------
>  include/linux/transaction_helper.h |  26 +++++++
>  lib/Makefile                       |   2 +-
>  lib/transaction_helper.c           | 137 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 179 insertions(+), 103 deletions(-)
>  create mode 100644 include/linux/transaction_helper.h
>  create mode 100644 lib/transaction_helper.c

Interesting, do you think there are other places that can use this
"transaction_helper" library?  And a bit more documentation would be
nice, but on the whole, no objection from me.

thanks,

greg k-h
