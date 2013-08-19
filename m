From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
Date: Mon, 19 Aug 2013 09:20:17 -0700
Message-ID: <CAGXu5jJtvVx76ZZrk+s4KwopT-ocZcMbwWNM1ELxH4crm=QGLw@mail.gmail.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
	<1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376928619-3775-5-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 9:10 AM, Matthew Garrett
<matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
> We have no way of validating what all of the Asus WMI methods do on a
> given machine, and there's a risk that some will allow hardware state to
> be manipulated in such a way that arbitrary code can be executed in the
> kernel, circumventing module loading restrictions. Prevent that if any of
> these features are enabled.
>
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/platform/x86/asus-wmi.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 19c313b..8105530 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1618,6 +1618,9 @@ static int show_dsts(struct seq_file *m, void *data)
>         int err;
>         u32 retval = -1;
>
> +       if (secure_modules())
> +               return -EPERM;
> +
>         err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
>
>         if (err < 0)
> @@ -1634,6 +1637,9 @@ static int show_devs(struct seq_file *m, void *data)
>         int err;
>         u32 retval = -1;
>
> +       if (!capable(CAP_COMPROMISE_KERNEL))

Looks like this and the next chunk weren't changed to the
secure_modules() API...

-Kees

> +               return -EPERM;
> +
>         err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
>                                     &retval);
>
> @@ -1658,6 +1664,9 @@ static int show_call(struct seq_file *m, void *data)
>         union acpi_object *obj;
>         acpi_status status;
>
> +       if (!capable(CAP_COMPROMISE_KERNEL))
> +               return -EPERM;
> +
>         status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
>                                      1, asus->debug.method_id,
>                                      &input, &output);
> --
> 1.8.3.1
>



-- 
Kees Cook
Chrome OS Security
