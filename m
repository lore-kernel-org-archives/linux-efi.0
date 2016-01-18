From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit
 is 0
Date: Mon, 18 Jan 2016 21:08:47 +0000
Message-ID: <20160118210847.GB2607@codeblueprint.co.uk>
References: <1452809107-17779-1-git-send-email-me@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452809107-17779-1-git-send-email-me-A/3C56C7qwM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Cc: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 14 Jan, at 11:05:07PM, M=F4she van der Sterre wrote:
> Unintuitively, the BGRT graphic is apparently meant to be usable if
> the valid bit in not set. The valid bit only conveys uncertainty
> about the validity in relation to the screen state.
>=20
> Windows 10 actually uses the BGRT image for its boot screen even if
> not 'valid', for example when the user triggered the boot menu.
> Because it is unclear if all firmwares will provide a usable graphic
> in this case, we now look at the BMP magic number as an additional
> check.
>=20
> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> Signed-off-by: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi-bgrt.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Thanks, applied!
