From: Namhyung Kim <namhyung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/18] pstore: Avoid race in module unloading
Date: Wed, 8 Mar 2017 01:16:43 +0900
Message-ID: <CADWwUUZAxwUqHU9eRrtP5Hk7KO9KkyvdBy7Z5Xehwhv43fvZVQ@mail.gmail.com>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org> <1488837332-71582-4-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488837332-71582-4-git-send-email-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Pan Xinhui <xinhui.pan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Daniel Axtens <dja-Yfaxwxk/+vWsTnJN9+BGXg@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-acp
List-Id: linux-efi@vger.kernel.org

Hi Kees,

On Tue, Mar 7, 2017 at 6:55 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> Technically, it might be possible for struct pstore_info to go out of
> scope after the module_put(), so report the backend name first.

But in that case, using pstore will crash the kernel anyway, right?
If so, why pstore doesn't keep a reference until unregister?
Do I miss something?

Thanks,
Namhyung


>
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> ---
>  fs/pstore/platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 074fe85a2078..d69ef8a840b9 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -722,10 +722,10 @@ int pstore_register(struct pstore_info *psi)
>          */
>         backend = psi->name;
>
> -       module_put(owner);
> -
>         pr_info("Registered %s as persistent store backend\n", psi->name);
>
> +       module_put(owner);
> +
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(pstore_register);
> --
> 2.7.4
>
