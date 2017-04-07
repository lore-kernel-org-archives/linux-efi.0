From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 15/24] asus-wmi: Restrict debugfs interface when the
 kernel is locked down
Date: Fri, 7 Apr 2017 13:25:43 +0300
Message-ID: <CAHp75VfpsnCHVqnFnwwh3JHB0ccY66Gj88sMGhrA9W7rDxiY_Q@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142340198.5101.8171352010918423590.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149142340198.5101.8171352010918423590.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, matthew.garrett@nebula.com, linux-efi@vger.kernel.org, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 5, 2017 at 11:16 PM, David Howells <dhowells@redhat.com> wrote:
> From: Matthew Garrett <matthew.garrett@nebula.com>
>
> We have no way of validating what all of the Asus WMI methods do on a given
> machine - and there's a risk that some will allow hardware state to be
> manipulated in such a way that arbitrary code can be executed in the
> kernel, circumventing module loading restrictions.  Prevent that if the
> kernel is locked down.

> +       if (kernel_is_locked_down())
> +               return -EPERM;

It looks a bit fragile when responsility of whatever reasons kernel
can't serve become a driver burden.
Can we fix this in debugfs framework instead?

> +
>         err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
>
>         if (err < 0)
> @@ -1916,6 +1919,9 @@ static int show_devs(struct seq_file *m, void *data)
>         int err;
>         u32 retval = -1;
>
> +       if (kernel_is_locked_down())
> +               return -EPERM;
> +
>         err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
>                                     &retval);
>
> @@ -1940,6 +1946,9 @@ static int show_call(struct seq_file *m, void *data)
>         union acpi_object *obj;
>         acpi_status status;
>
> +       if (kernel_is_locked_down())
> +               return -EPERM;
> +
>         status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
>                                      1, asus->debug.method_id,
>                                      &input, &output);
>



-- 
With Best Regards,
Andy Shevchenko
