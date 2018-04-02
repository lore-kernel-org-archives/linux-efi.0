From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 3/8] efi: Decode IA32/X64 Processor Error Info Structure
Date: Mon, 2 Apr 2018 15:22:06 +0200
Message-ID: <CAKv+Gu_6=WEapKMaqpkg+qKh1f4HqQRx0ascZXfr4HYJAPOBnA@mail.gmail.com>
References: <20180324184940.19762-1-Yazen.Ghannam@amd.com> <20180324184940.19762-4-Yazen.Ghannam@amd.com>
 <20180329105448.GB29198@pd.tnic> <DM5PR12MB19162707D0F98D1A061F0A7AF8A20@DM5PR12MB1916.namprd12.prod.outlook.com>
 <CAKv+Gu_6D03iGvxsmiQS_ODET2cv4f7kVsK5S5EKhiVN1YxRaw@mail.gmail.com> <DM5PR12MB1916AC5CC36AEF4364C7D317F8A60@DM5PR12MB1916.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DM5PR12MB1916AC5CC36AEF4364C7D317F8A60@DM5PR12MB1916.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On 2 April 2018 at 15:21, Ghannam, Yazen <Yazen.Ghannam@amd.com> wrote:
>> -----Original Message-----
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Sent: Friday, March 30, 2018 7:25 AM
>> To: Ghannam, Yazen <Yazen.Ghannam@amd.com>
>> Cc: Borislav Petkov <bp@alien8.de>; linux-efi@vger.kernel.org; linux-
>> kernel@vger.kernel.org; x86@kernel.org; tony.luck@intel.com
>> Subject: Re: [PATCH v3 3/8] efi: Decode IA32/X64 Processor Error Info Structure
>>
>> On 29 March 2018 at 14:53, Ghannam, Yazen <Yazen.Ghannam@amd.com>
>> wrote:
>> >> -----Original Message-----
>> >> From: Borislav Petkov <bp@alien8.de>
>> >> Sent: Thursday, March 29, 2018 6:55 AM
>> >> To: Ghannam, Yazen <Yazen.Ghannam@amd.com>
>> >> Cc: linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org;
>> >> ard.biesheuvel@linaro.org; x86@kernel.org; tony.luck@intel.com
>> >> Subject: Re: [PATCH v3 3/8] efi: Decode IA32/X64 Processor Error Info
>> >> Structure
>> >>
>> >> On Sat, Mar 24, 2018 at 01:49:35PM -0500, Yazen Ghannam wrote:
>> >> > From: Yazen Ghannam <yazen.ghannam@amd.com>
>> >> >
>> >> > Print the fields in the IA32/X64 Processor Error Info Structure.
>> >> >
>> >> > Based on UEFI 2.7 Table 253. IA32/X64 Processor Error Information
>> >> > Structure.
>> >> >
>> >> > Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
>> >> > ---
>> >> > Link:
>> >> > https://lkml.kernel.org/r/20180226193904.20532-4-
>> >> Yazen.Ghannam@amd.com
>> >> >
>> >> > v2->v3:
>> >> > * Fix table number in commit message.
>> >> > * Don't print raw validation bits.
>> >> >
>> >> > v1->v2:
>> >> > * Add parantheses around "bits" expression in macro.
>> >> > * Fix indentation on multi-line statements.
>> >> >
>> >> >  drivers/firmware/efi/cper-x86.c | 50
>> >> +++++++++++++++++++++++++++++++++++++++++
>> >> >  1 file changed, 50 insertions(+)
>> >> >
>> >> > diff --git a/drivers/firmware/efi/cper-x86.c b/drivers/firmware/efi/cper-
>> >> x86.c
>> >> > index 863f0cd2a0ff..a9ab3bbf7986 100644
>> >> > --- a/drivers/firmware/efi/cper-x86.c
>> >> > +++ b/drivers/firmware/efi/cper-x86.c
>> >> > @@ -3,15 +3,28 @@
>> >> >
>> >> >  #include <linux/cper.h>
>> >> >
>> >> > +#define INDENT_SP  " "
>> >>
>> >> There's that thing again. So it was a total waste of time discussing
>> >> this last time. So let me save my time this time:
>> >>
>> >> NAKed-by: Borislav Petkov <bp@suse.de>
>> >>
>> >
>> > IIRC, the arguments for keeping this are
>> > 1) convention for CPER
>> > 2) code readability
>> >
>> > The argument against was
>> > 1) it's dumb
>> >
>> > So I decided to keep it. I don't really mind either way so I'll change it
>> > if there's a second opinion.
>> >
>>
>> Yes, please change it.
>
> Okay, will do. Should I include a patch that changes it for the other CPER
> code also?
>

No worries, Boris already sent that out.
