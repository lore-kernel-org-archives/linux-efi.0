From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3 V2] efi/efi_test: use memdup_user() as a cleanup
Date: Wed, 5 Oct 2016 11:37:14 +0100
Message-ID: <20161005103714.GW16071@codeblueprint.co.uk>
References: <1475633254-6815-1-git-send-email-ivan.hu@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475633254-6815-1-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Oct, at 10:07:34AM, Ivan Hu wrote:
> Fix coccicheck warning which recommends to use memdup_user()
> 
> This patch fixes below coccicheck warnings:
> drivers/firmware/efi/test/efi_test.c:269:8-15: WARNING opportunity for
> memdup_user
> 
> Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/firmware/efi/test/efi_test.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Thanks, applied to 'next'.
