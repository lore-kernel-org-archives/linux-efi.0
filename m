From: Seth Forshee <seth.forshee@canonical.com>
Subject: Problem mounting efivarfs in 3.9
Date: Thu, 7 Mar 2013 08:56:01 -0600
Message-ID: <20130307145601.GA24233@thinkpad-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

I found myself unable to mount efivarfs on one of my machines in 3.9.
This is due to your patch to be more aggressive about validating
filenames. This machine had some crash dumps from pstore, which start
with "dump-type". However now efivars expects the guid to follow the
first '-' character, despite the fact that the efivars pstore code is
creating the file names starting with dump-type. Since these names fail
the validation the mount fails.

These changes are now in some of the stable releases as well (3.8.x at
minumum).

Thanks,
Seth
