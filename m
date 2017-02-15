From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Wed, 15 Feb 2017 19:50:38 +0100
Message-ID: <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2017-02-15 19:46, Andy Shevchenko wrote:
> On Wed, Feb 15, 2017 at 8:14 PM, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
>> See patch 2 for the background.
>>
>> Series has been tested on the Galileo Gen2, to exclude regressions, with
>> a firmware.cap without security header and the SIMATIC IOT2040 which
>> requires the header because of its mandatory secure boot.
> 
> Briefly looking to the code it looks like a real hack.
> Sorry, but it would be carefully (re-)designed.

The interface that the firmware provides us? That should have been done
differently, I agree, but I'm not too much into those firmware details,
specifically when it comes to signatures.

The Linux code was designed around that suboptimal situation. If there
are better ideas, I'm all ears.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA ITP SES-DE
Corporate Competence Center Embedded Linux
