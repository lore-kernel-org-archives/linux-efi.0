From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: Problem mounting efivarfs in 3.9
Date: Thu, 07 Mar 2013 15:02:38 +0000
Message-ID: <1362668558.15011.203.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20130307145601.GA24233@thinkpad-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130307145601.GA24233@thinkpad-t410>
Sender: stable-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, stable@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-03-07 at 08:56 -0600, Seth Forshee wrote:
> Hi Matt,
> 
> I found myself unable to mount efivarfs on one of my machines in 3.9.
> This is due to your patch to be more aggressive about validating
> filenames. This machine had some crash dumps from pstore, which start
> with "dump-type". However now efivars expects the guid to follow the
> first '-' character, despite the fact that the efivars pstore code is
> creating the file names starting with dump-type. Since these names fail
> the validation the mount fails.

A patch to allow pstore names is in the pull request I sent to Peter and
Ingo yesterday,

	http://marc.info/?l=linux-kernel&m=136258373231608&w=2
