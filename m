From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] efi/efi_test: use memdup_user
Date: Wed, 10 May 2017 11:35:17 +0100
Message-ID: <20170510103517.GA6562@codeblueprint.co.uk>
References: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
 <20170505205349.GC5225@codeblueprint.co.uk>
 <0d6b6b9e-de5c-4eb2-f46a-d26ae058fa42@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0d6b6b9e-de5c-4eb2-f46a-d26ae058fa42-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ivanhu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 08 May, at 04:18:30PM, Ivan Hu wrote:
> 
> 
> On 05/06/2017 04:53 AM, Matt Fleming wrote:
> >On Sat, 29 Apr, at 09:42:52AM, Geliang Tang wrote:
> >>Use memdup_user() helper instead of open-coding to simplify the code.
> >>
> >>Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>---
> >> drivers/firmware/efi/test/efi_test.c | 11 +++--------
> >> 1 file changed, 3 insertions(+), 8 deletions(-)
> >
> >This one looks fine. Ivan, do you want to ACK it?
> >
> 
> Looks fine to me too, ACK. Thanks!

Applied, thanks everyone.
