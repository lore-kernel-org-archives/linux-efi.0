From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/24] uswsusp: Disable when the kernel is locked down
Date: Thu, 6 Apr 2017 22:09:47 +0200
Message-ID: <CAJZ5v0gFeF3hdr0QzUeaT2dS+HhG7KUdVPPWHKeqHVkX78s+Tw@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142336965.5101.2946578135980499557.stgit@warthog.procyon.org.uk>
 <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com>
 <1491460792.1645.1.camel@suse.com> <14980.1491468060@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14980.1491468060-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux PM <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 6, 2017 at 10:41 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org> wrote:
>
>> Your swap partition may be located on an NVDIMM or be encrypted.
>
> An NVDIMM should be considered the same as any other persistent storage.
>
> It may be encrypted, but where's the key stored, how easy is it to retrieve
> and does the swapout code know this?
>
>> Isn't this a bit overly drastic?
>
> Perhaps, but if it's on disk and it's not encrypted, then maybe not.

Right.

Swap encryption is not mandatory and I'm not sure how the hibernate
code can verify whether or not it is in use.

Thanks,
Rafael
