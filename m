From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Clean up a minor mistake in code comment
Date: Fri, 24 Mar 2017 09:43:34 +0000
Message-ID: <CAKv+Gu_ojQ48eTqqd3m9SxqqLygVPFGAUWJHxjznr8t6WYbygQ@mail.gmail.com>
References: <1490347040-28720-1-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490347040-28720-1-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 09:17, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> EFI allocate runtime services regions from EFI_VA_START, -4G, down
> to -68G, EFI_VA_END, 64G altogether. The mechanism was introduced in
> commit d2f7cbe7b26a7 ("x86/efi: Runtime services virtual mapping").
>
> Clean it up to avoid confusion.
>
> Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> v1->v2:
>   Update patch log to corret a description mistake Ard pointed out.
>

Queued in efi/next for v4.12

Thanks,
Ard.
