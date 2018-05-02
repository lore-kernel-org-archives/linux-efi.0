From: "Yang, Shunyong" <shunyong.yang@hxt-semitech.com>
Subject: Re: [PATCH] efi/capsule-loader: Don't output reset log when header
 flags is not set
Date: Wed, 2 May 2018 01:29:55 +0000
Message-ID: <1525224594.2901.4.camel@hxt-semitech.com>
References: <1524625806-23133-1-git-send-email-shunyong.yang@hxt-semitech.com>
         <CAKv+Gu89B-E+L2qybT9n5j72c+1vm1az4H9Cp7E71aP3i3VE6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu89B-E+L2qybT9n5j72c+1vm1az4H9Cp7E71aP3i3VE6A@mail.gmail.com>
Content-Language: en-US
Content-ID: <61C00092B24DA84CA2D1348016E5D5D3@hxt-semitech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zheng, Joey" <yu.zheng@hxt-semitech.com>
List-Id: linux-efi@vger.kernel.org

Hi, Ard,

On Tue, 2018-05-01 at 11:54 +0200, Ard Biesheuvel wrote:
> On 25 April 2018 at 05:10, Shunyong Yang <shunyong.yang@hxt-semitech.
> com> wrote:
> > 
> > It means firmware attempts to immediately process or launch the
> > capsule
> > when flags in capsule header is not set. Moreover, reset is not
> > needed
> > in this case. Current code will output log to indicate reset.
> > 
> > This patch adds a branch to avoid reset log output when the flags
> > is not
> > set.
> > 
> > Cc: Joey Zheng <yu.zheng@hxt-semitech.com>
> > Signed-off-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
> > ---
> >  drivers/firmware/efi/capsule-loader.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/firmware/efi/capsule-loader.c
> > b/drivers/firmware/efi/capsule-loader.c
> > index e456f4602df1..a63b8e5bde23 100644
> > --- a/drivers/firmware/efi/capsule-loader.c
> > +++ b/drivers/firmware/efi/capsule-loader.c
> > @@ -134,10 +134,15 @@ static ssize_t
> > efi_capsule_submit_update(struct capsule_info *cap_info)
> > 
> >         /* Indicate capsule binary uploading is done */
> >         cap_info->index = NO_FURTHER_WRITE_ACTION;
> > -       pr_info("Successfully upload capsule file with reboot type
> > '%s'\n",
> > -               !cap_info->reset_type ? "RESET_COLD" :
> > -               cap_info->reset_type == 1 ? "RESET_WARM" :
> > -               "RESET_SHUTDOWN");
> > +
> > +       if (cap_info->header.flags)
> You should check for the relevant flag bits here, because the 16
> lower
> bits are platform dependent.
In current three bits in flags, CAPSULE_FLAGS_POPULATE_SYSTEM_TABLE and
CAPSULE_FLAGS_INITIATE_RESET are dependent on
CAPSULE_FLAGS_PERSIST_ACROSS_RESET.

So, maybe I only need to check CAPSULE_FLAGS_PERSIST_ACROSS_RESET?

Thanks.
Shunyong.
> 
> > 
> > +               pr_info("Successfully upload capsule file with
> > reboot type '%s'\n",
> > +                       !cap_info->reset_type ? "RESET_COLD" :
> > +                       cap_info->reset_type == 1 ? "RESET_WARM" :
> > +                       "RESET_SHUTDOWN");
> > +       else
> > +               pr_info("Successfully upload, process and launch
> > capsule file\n");
> > +
> >         return 0;
> >  }
> > 
> > --
> > 1.8.3.1
> > 
