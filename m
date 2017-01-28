From: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REGRESSION] EFI mixed mode patch triggers boot failure
Date: Sat, 28 Jan 2017 09:35:23 +0100
Message-ID: <f7d8f786-6000-cbbe-feb2-c97c0378b6e9@redhat.com>
References: <dc0bc031-f20e-9ad0-57f4-cfa1e04f8f05@redhat.com>
 <7af87cde-ce79-d6e8-0797-54069a77f42b@redhat.com>
 <20161020120357.GB19876@codeblueprint.co.uk>
 <e34311e8-fe39-3b65-bd6d-8f1594e56336@redhat.com>
 <20170127223441.GJ31613@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170127223441.GJ31613-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Justin Forbes <jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/27/2017 11:34 PM, Matt Fleming wrote:
> On Mon, 24 Oct, at 12:54:11PM, Laura Abbott wrote:
>>
>> Was out for a few days, reporter says the below patch does not work.
>> There was some confusion with secure boot so I've asked them to re-test
>> with efi=old_map and secure boot off.
>
> FYI, you may want to ask the reporter to try out Jiri's patch if this
> is still an issue for them,
>
>   https://lkml.kernel.org/r/alpine.LSU.2.20.1701271638240.25515-YHPUNQjx9ReKbouaWp301Q@public.gmane.org
>

Thanks! I pulled this into the latest Fedora update so I'll be asking
a couple of people to test.

Thanks,
Laura
