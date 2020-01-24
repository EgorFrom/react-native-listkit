/* @flow */

import * as React from 'react';
import { requireNativeComponent } from 'react-native';

const RNLGridView = requireNativeComponent('RNLGridView');

export const Swiper = (props) => ( <RNLGridView {...props} /> );

export default Swiper;
