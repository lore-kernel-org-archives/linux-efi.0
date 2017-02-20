From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: libstub: treat missing SecureBoot variable as S/B disabled
Date: Mon, 20 Feb 2017 08:53:57 +0000
Message-ID: <34A83E6D-1162-4055-9ACF-A32AFC837CA4@linaro.org>
References: <CAKv+Gu_=BwvYJoyuf89PUVjnrJeJyvr-p6yFAu4Mw+ErLc4nxQ@mail.gmail.com> <1487268503-21570-1-git-send-email-ard.biesheuvel@linaro.org> <20170217051355.GA1141@wunner.de> <12887.1487321781@warthog.procyon.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12887.1487321781-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> On 17 Feb 2017, at 08:56, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 
>> But I did not appreciate at the time that this was a change in
>> behavior nonetheless, and printing errors that are not errors only
>> confuses people.
> 
> Perhaps just take the error message out and leave it to the main kernel to
> deal with?
> 

No, a non-existent SecureBoot variable is simply not an error condition
