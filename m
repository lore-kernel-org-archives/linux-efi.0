From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Wed, 19 Mar 2014 13:16:15 -0700
Message-ID: <CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw@mail.gmail.com>
References: <1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<20140314231832.GA653@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140314231832.GA653-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 14, 2014 at 4:18 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Fri, Mar 14, 2014 at 10:08:40PM +0000, One Thousand Gnomes wrote:
>> > Signed userspace is not a requirement, and therefore any solution that
>> > relies on a signed initrd is inadequate. There are use cases that
>> > require verification of the initrd and other levels. This isn't one of
>> > them.
>>
>> The job of the kernel is to solve the general problem. There are lots of
>> people who happen to care about verification beyond the kernel so it
>> shouldn't be ignored. And they can do do things like load trusted SELinux
>> rulesets even if you can't support it in your environment.
>
> This is really a question about goals and trust models.  Alan is
> arguing that we should support trust models and goals which go far
> beyond the goals and trust model of the UEFI Forum.
>
> Matthew is, I think, trying to make the argument that his patches
> fulfill the goals that are needed so we can boot Linux distribution
> kernels on UEFI secure boot machines without worrying about Microsoft
> deciding to revoke keys so that Red Hat or SuSE will no longer be able
> to be bootable on desktops that are certified for Windows 8.  And
> while we might want to improve the framework to support other trust
> models later on, supporting distro kernels on Windows 8 certified PC's
> is important enough that we should let these patches into mainline.
>
> Is that a fair summary of the two viewpoints?

UEFI is a red herring in both cases. This isn't about UEFI, it just
happens that one of the things that can assert "trusted_kernel" is the
UEFI Secure Boot path. Chrome OS would assert "trusted_kernel" by
passing it on the kernel command line (since it, along with firmware,
kernel, and root fs are effectively measured). A
boot-my-router-from-CD system can assert similarly because the kernel
is on RO media.

Based on my view of the conversation, it's about whether or not
capable() can be made to do these checks. The proposal about creating
the action/privilege map is interesting, and I'm all for doing it just
to make things easy to reason about for capabilities, but it still
seems separate from this work.

There still needs to be a global boolean for the "trusted kernel"
state. It would be used, for example, on the module param
whitelisting, which has nothing to do with capabilities. It would be
used to change driver behavior (e.g. disabling DMA or other badness
that isn't trusted), which has nothing to do with capabilities. The
ability to check this state is going to be needed going into the
future as we uncover more dangerous interfaces.

Since the capability work is separate, when it happens, that same
regex work could replace some of the is_trusted_kernel checks with new
action tests, but we still need the same infrastructure and
identification of dangerous interfaces.

Capabilities can be seen as related to this patch set, but it cannot
be seen as a blocker. This logic is needed today, it's implemented,
and it clearly marks where the known problems are. If an overhaul of
capabilities happens, it can happen separately.

-Kees

-- 
Kees Cook
Chrome OS Security
